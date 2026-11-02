import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/constants/app_config.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

/// Offline-first storage: every change is written to the device immediately.
///
/// Deleted tasks leave a "tombstone" (id + deletion time) so a later cloud
/// sync can tell "deleted on purpose" from "never existed".
class LocalTaskService extends GetxService implements TaskRepository {
  final GetStorage _box = GetStorage();
  final Map<String, DateTime> _tombstones = <String, DateTime>{};

  @override
  final RxList<TaskModel> tasks = <TaskModel>[].obs;

  /// Deleted task ids with their deletion time (used by sync).
  Map<String, DateTime> get tombstones =>
      Map<String, DateTime>.unmodifiable(_tombstones);

  DateTime _now() => DateTime.now().toUtc();

  @override
  Future<void> load() async {
    final String? raw = _box.read<String>(AppConfig.tasksStorageKey);
    if (raw != null) {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      tasks.assignAll(
        list.map((dynamic e) => TaskModel.fromJson(e as Map<String, dynamic>)),
      );
    }
    final String? deleted = _box.read<String>(AppConfig.tombstonesStorageKey);
    if (deleted != null) {
      final Map<String, dynamic> map =
          jsonDecode(deleted) as Map<String, dynamic>;
      _tombstones
        ..clear()
        ..addAll(
          map.map(
            (String id, dynamic v) =>
                MapEntry<String, DateTime>(id, DateTime.parse(v as String)),
          ),
        );
    }
  }

  @override
  TaskModel? byId(String id) =>
      tasks.firstWhereOrNull((TaskModel t) => t.id == id);

  @override
  Future<void> save(TaskModel task) async {
    _upsert(task.copyWith(updatedAt: _now()));
    _tombstones.remove(task.id);
    await _persist();
  }

  @override
  Future<void> delete(String id) async {
    if (byId(id) == null) return;
    tasks.removeWhere((TaskModel t) => t.id == id);
    _tombstones[id] = _now();
    await _persist();
  }

  @override
  Future<void> setDone(String id, DateTime day, {required bool done}) =>
      _update(id, (TaskModel t) => t.withDone(day, done: done));

  @override
  Future<void> setPinned(String id, {required bool pinned}) =>
      _update(id, (TaskModel t) => t.copyWith(isPinned: pinned));

  // ---------------------------------------------------------------------------
  // Applying changes that arrive from the cloud (last writer wins)
  // ---------------------------------------------------------------------------

  Future<void> applyRemote(TaskModel remote) async {
    final DateTime? deletedAt = _tombstones[remote.id];
    if (deletedAt != null && !remote.updatedAt.isAfter(deletedAt)) return;
    final TaskModel? local = byId(remote.id);
    if (local != null && !remote.updatedAt.isAfter(local.updatedAt)) return;
    _upsert(remote);
    _tombstones.remove(remote.id);
    await _persist();
  }

  Future<void> applyRemoteDelete(String id, DateTime deletedAt) async {
    final TaskModel? local = byId(id);
    if (local != null && local.updatedAt.isAfter(deletedAt)) return;
    tasks.removeWhere((TaskModel t) => t.id == id);
    final DateTime? known = _tombstones[id];
    if (known == null || deletedAt.isAfter(known)) _tombstones[id] = deletedAt;
    await _persist();
  }

  void _upsert(TaskModel task) {
    final int index = tasks.indexWhere((TaskModel t) => t.id == task.id);
    if (index == -1) {
      tasks.add(task);
    } else {
      tasks[index] = task;
    }
  }

  Future<void> _update(String id, TaskModel Function(TaskModel) change) async {
    final int index = tasks.indexWhere((TaskModel t) => t.id == id);
    if (index == -1) return;
    tasks[index] = change(tasks[index]).copyWith(updatedAt: _now());
    await _persist();
  }

  Future<void> _persist() async {
    await _box.write(
      AppConfig.tasksStorageKey,
      jsonEncode(tasks.map((TaskModel t) => t.toJson()).toList()),
    );
    await _box.write(
      AppConfig.tombstonesStorageKey,
      jsonEncode(
        _tombstones.map(
          (String id, DateTime at) =>
              MapEntry<String, String>(id, at.toIso8601String()),
        ),
      ),
    );
  }
}
