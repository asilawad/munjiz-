import 'dart:async';

import 'package:get/get.dart';

import '../models/task_model.dart';
import '../services/local_task_service.dart';
import '../services/task_sync_service.dart';
import 'task_repository.dart';

/// Local-first repository that mirrors every change to Firestore.
/// The UI and controllers keep talking to [TaskRepository] only.
class SyncedTaskRepository implements TaskRepository {
  SyncedTaskRepository(this._local, this._sync);

  final LocalTaskService _local;
  final TaskSyncService _sync;

  @override
  RxList<TaskModel> get tasks => _local.tasks;

  @override
  Future<void> load() async {
    await _local.load();
    unawaited(_sync.start());
  }

  @override
  TaskModel? byId(String id) => _local.byId(id);

  @override
  Future<void> save(TaskModel task) async {
    await _local.save(task);
    _mirror(task.id);
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
    _mirror(id);
  }

  @override
  Future<void> setDone(String id, DateTime day, {required bool done}) async {
    await _local.setDone(id, day, done: done);
    _mirror(id);
  }

  @override
  Future<void> setPinned(String id, {required bool pinned}) async {
    await _local.setPinned(id, pinned: pinned);
    _mirror(id);
  }

  /// Sends the task's current state (or its deletion) to the cloud.
  void _mirror(String id) {
    final TaskModel? task = _local.byId(id);
    if (task != null) {
      _sync.pushTask(task);
      return;
    }
    final DateTime? deletedAt = _local.tombstones[id];
    if (deletedAt != null) _sync.pushDeleted(id, deletedAt);
  }
}
