import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Global light theme. Component themes style Material widgets once so custom
/// widgets never define their own colors, radii or text styles.
abstract final class AppTheme {
  static final ThemeData light = _build();

  static const TextTheme _textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: AppDimensions.fontXxl,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: AppDimensions.lineHeight,
    ),
    titleLarge: TextStyle(
      fontSize: AppDimensions.fontXl,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: AppDimensions.lineHeight,
    ),
    titleMedium: TextStyle(
      fontSize: AppDimensions.fontLg,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: AppDimensions.lineHeight,
    ),
    bodyLarge: TextStyle(
      fontSize: AppDimensions.fontMd,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: AppDimensions.lineHeight,
    ),
    bodyMedium: TextStyle(
      fontSize: AppDimensions.fontSm,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: AppDimensions.lineHeight,
    ),
    bodySmall: TextStyle(
      fontSize: AppDimensions.fontXs,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: AppDimensions.lineHeight,
    ),
    labelLarge: TextStyle(
      fontSize: AppDimensions.fontMd,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: TextStyle(
      fontSize: AppDimensions.fontSm,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: AppDimensions.fontXs,
      fontWeight: FontWeight.w700,
    ),
  );

  static ThemeData _build() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.cyan,
        tertiary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconMd,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.transparent,
        surfaceTintColor: AppColors.transparent,
        elevation: AppDimensions.elevationNone,
        scrolledUnderElevation: AppDimensions.elevationNone,
        centerTitle: true,
        titleTextStyle: _textTheme.titleMedium,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: AppDimensions.cardPadding,
        hintStyle: _textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
        errorStyle: _textTheme.bodySmall?.copyWith(color: AppColors.danger),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(
          AppColors.primary,
          AppDimensions.borderWidthSelected,
        ),
        errorBorder: _inputBorder(AppColors.danger),
        focusedErrorBorder: _inputBorder(
          AppColors.danger,
          AppDimensions.borderWidthSelected,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        shape: CircleBorder(),
        sizeConstraints: BoxConstraints.tightFor(
          width: AppDimensions.fabSize,
          height: AppDimensions.fabSize,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll<Color>(AppColors.onPrimary),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.border,
        ),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          AppColors.transparent,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: _textTheme.bodyLarge?.copyWith(
          color: AppColors.onPrimary,
        ),
        actionTextColor: AppColors.accent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLg,
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(
    Color color, [
    double width = AppDimensions.borderWidth,
  ]) {
    return OutlineInputBorder(
      borderRadius: AppDimensions.borderRadiusLg,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
