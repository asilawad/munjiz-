import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../core/constants/app_config.dart';
import '../models/task_model.dart';
import 'auth_service.dart';
import 'local_task_service.dart';

/// Two-way sync between local storage and `users/{uid}/tasks` in Firestore.
///
/// Local storage always stays the source of truth for the UI. Writes to
/// Firestore are never awaited (the SDK queues them while offline), and the
/// newest `updatedAt` wins when both sides changed the same task.
class TaskSyncService with WidgetsBindingObserver {
  TaskSyncService(this._local, this._auth);

  final LocalTaskService _local;
  final AuthService _auth;

  CollectionReference<Map<String, dynamic>>? _collection;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  bool _initialPushDone = false;
  bool _observing = false;
  bool _starting = false;

  /// Safe to call repeatedly; retries after launch-time failures (e.g. offline).
  Future<void> start() async {
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
    if (_subscription != null || _starting) return;
    _starting = true;
    try {
      final String? uid = await _auth.ensureSignedIn();
      if (uid == null) return;
      final CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance
              .collection(AppConfig.usersCollection)
              .doc(uid)
              .collection(AppConfig.tasksCollection);
      _collection = collection;
      _subscription = collection.snapshots().listen(
        _onSnapshot,
        onError: (Object _) {},
      );
    } finally {
      _starting = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) start();
  }

  void pushTask(TaskModel task) {
    final CollectionReference<Map<String, dynamic>>? col = _collection;
    if (col == null) return;
    unawaited(
      col
          .doc(task.id)
          .set(<String, dynamic>{...task.toJson(), 'isDeleted': false})
          .catchError((Object _) {}),
    );
  }

  void pushDeleted(String id, DateTime deletedAt) {
    final CollectionReference<Map<String, dynamic>>? col = _collection;
    if (col == null) return;
    unawaited(
      col
          .doc(id)
          .set(<String, dynamic>{
            'id': id,
            'isDeleted': true,
            'updatedAt': deletedAt.toIso8601String(),
          })
          .catchError((Object _) {}),
    );
  }

  Future<void> _onSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) async {
    for (final DocumentChange<Map<String, dynamic>> change
        in snapshot.docChanges) {
      // Echo of our own queued write: nothing to merge.
      if (change.doc.metadata.hasPendingWrites) continue;
      final Map<String, dynamic>? data = change.doc.data();
      if (data == null) continue;
      try {
        final DateTime? at = DateTime.tryParse(
          (data['updatedAt'] as String?) ?? '',
        );
        if (data['isDeleted'] == true) {
          if (at != null) await _local.applyRemoteDelete(change.doc.id, at);
        } else {
          await _local.applyRemote(TaskModel.fromJson(data));
        }
      } catch (_) {
        // Skip a malformed document instead of breaking the whole sync.
      }
    }
    if (!_initialPushDone) {
      _initialPushDone = true;
      _pushMissing(snapshot);
    }
  }

  /// First sync: upload local changes the cloud does not have yet.
  void _pushMissing(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final Map<String, DateTime> remote = <String, DateTime>{
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs)
        doc.id:
            DateTime.tryParse((doc.data()['updatedAt'] as String?) ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
    };
    for (final TaskModel task in _local.tasks) {
      final DateTime? at = remote[task.id];
      if (at == null || task.updatedAt.isAfter(at)) pushTask(task);
    }
    _local.tombstones.forEach((String id, DateTime deletedAt) {
      final DateTime? at = remote[id];
      if (at == null || deletedAt.isAfter(at)) pushDeleted(id, deletedAt);
    });
  }
}
