import 'task_category.dart';

/// One selectable category filter chip (built-in or user-defined "Other").
class CategoryOption {
  const CategoryOption({
    required this.key,
    required this.label,
    required this.category,
  });

  final String key;
  final String label;
  final TaskCategory category;
}
