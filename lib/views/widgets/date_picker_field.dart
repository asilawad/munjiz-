import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_strings.dart';

/// Read-only field that opens the date picker; can be cleared.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - AppConfig.datePickerYearsBack),
      lastDate: DateTime(now.year + AppConfig.datePickerYearsForward),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? date = value;
    return GestureDetector(
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today_rounded),
          suffixIcon: date == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(
          date == null
              ? AppStrings.noDate
              : DateFormat(AppStrings.dateFormat).format(date),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: date == null ? AppColors.textHint : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
