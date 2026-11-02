import '../constants/app_strings.dart';

abstract final class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    return null;
  }
}
