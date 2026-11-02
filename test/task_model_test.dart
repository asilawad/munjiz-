import 'package:flutter_test/flutter_test.dart';
import 'package:munjiz/data/models/task_category.dart';
import 'package:munjiz/data/models/task_model.dart';

void main() {
  final DateTime monday = DateTime(2026, 11, 2); // weekday == 1
  final DateTime tuesday = DateTime(2026, 11, 3);

  TaskModel routine({List<int> days = const <int>[]}) => TaskModel(
    id: '1',
    title: 'روتين',
    category: TaskCategory.personal,
    createdAt: DateTime(2026, 10, 1),
    isRoutine: true,
    routineDays: days,
  );

  test('daily routine occurs every day', () {
    expect(routine().occursOn(monday), isTrue);
    expect(routine().occursOn(tuesday), isTrue);
  });

  test('specific-day routine occurs only on its days', () {
    final TaskModel t = routine(days: <int>[DateTime.monday]);
    expect(t.occursOn(monday), isTrue);
    expect(t.occursOn(tuesday), isFalse);
  });

  test('routine completion is tracked per day', () {
    final TaskModel done = routine().withDone(monday, done: true);
    expect(done.isDoneOn(monday), isTrue);
    expect(done.isDoneOn(tuesday), isFalse);
    expect(done.withDone(monday, done: false).isDoneOn(monday), isFalse);
  });

  test('json round trip keeps data', () {
    final TaskModel t = routine(days: <int>[1, 3]).copyWith(isPinned: true);
    final TaskModel back = TaskModel.fromJson(t.toJson());
    expect(back.routineDays, <int>[1, 3]);
    expect(back.isPinned, isTrue);
    expect(back.title, t.title);
  });
}
