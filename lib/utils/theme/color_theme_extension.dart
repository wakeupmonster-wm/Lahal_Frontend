// app_colors.dart
import 'package:flutter/material.dart';

/// Non-Material tokens you still want themed (cards, chips, custom badges, etc.)
class AppColors extends ThemeExtension<AppColors> {
  final Color info;
  final Color success;
  final Color warning;
  final Color error;

  const AppColors({
    required this.info,
    required this.success,
    required this.warning,
    required this.error,
  });

  @override
  AppColors copyWith({
    Color? info,
    Color? success,
    Color? warning,
    Color? error,
    Color? card,
    Color? outlineSoft,
  }) {
    return AppColors(
      info: info ?? this.info,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      info: Color.lerp(info, other.info, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
