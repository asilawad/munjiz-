import 'package:get/get.dart';

import '../models/task_model.dart';

/// Contract between controllers and the storage layer.
abstract interface class TaskRepository {
  /// Live list of all tasks.
  RxList<TaskModel> get tasks;

  /// Reads tasks from local storage. Throws if the stored data is corrupted.
  Future<void> load();

  TaskModel? byId(String id);

  /// Adds the task, or replaces the one with the same id.
  Future<void> save(TaskModel task);

  Future<void> delete(String id);

  /// Marks a task done / not done on [day] (routines are tracked per day).
  Future<void> setDone(String id, DateTime day, {required bool done});

  Future<void> setPinned(String id, {required bool pinned});
}
