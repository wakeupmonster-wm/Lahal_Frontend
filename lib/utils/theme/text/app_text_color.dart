// =============================
// lib/theme/app_text_colors.dart
// ThemeExtension for text color tokens (6 main + 3 status)
// =============================

import 'package:flutter/material.dart';

/// ThemeExtension for text color tokens (main text roles + statuses)
/// Kept small and semantic so developers use roles instead of hexes.
class AppTextColors extends ThemeExtension<AppTextColors> {
  /// brand / link color (for tappable text, links)
  final Color link;

  /// brand accent (primary use, e.g., highlight text)
  final Color primary;

  /// secondary accent (rare, small accents)
  final Color secondary;

  /// tertiary (alternate accent)
  final Color tertiary;

  /// neutral / default text color (body & headings)
  final Color neutral;

  /// inverse text used on colored surfaces (e.g., text on primary)
  final Color inverse;

  /// subtle / caption / placeholder / hints
  final Color subtle;

  /// muted (slightly different from subtle — used for timestamps, disabled states)
  final Color muted;

  /// semantic statuses
  final Color info;
  final Color warning;
  final Color error;

  const AppTextColors({
    required this.link,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.inverse,
    required this.subtle,
    required this.muted,
    required this.info,
    required this.warning,
    required this.error,
  });

  @override
  AppTextColors copyWith({
    Color? link,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? neutral,
    Color? inverse,
    Color? subtle,
    Color? muted,
    Color? info,
    Color? warning,
    Color? error,
  }) {
    return AppTextColors(
      link: link ?? this.link,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      neutral: neutral ?? this.neutral,
      inverse: inverse ?? this.inverse,
      subtle: subtle ?? this.subtle,
      muted: muted ?? this.muted,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  AppTextColors lerp(ThemeExtension<AppTextColors>? other, double t) {
    if (other is! AppTextColors) return this;
    return AppTextColors(
      link: Color.lerp(link, other.link, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      inverse: Color.lerp(inverse, other.inverse, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
