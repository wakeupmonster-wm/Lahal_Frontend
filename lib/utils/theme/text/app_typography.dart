// =============================
// lib/theme/app_typography.dart
// ThemeExtension for semantic text sizes (24,18,16,14,12,10) + weights
// =============================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTextSize { s24, s18, s16, s14, s12, s10 }

enum AppTextWeight { regular, medium, semibold, bold, extraBold }

FontWeight _mapWeight(AppTextWeight w) {
  switch (w) {
    case AppTextWeight.extraBold:
      return FontWeight.w800; // or w900 if needed
    case AppTextWeight.bold:
      return FontWeight.w700;
    case AppTextWeight.semibold:
      return FontWeight.w600;
    case AppTextWeight.medium:
      return FontWeight.w500;
    default:
      return FontWeight.w400;
  }
}

class AppTypography extends ThemeExtension<AppTypography> {
  final TextStyle s24;
  final TextStyle s18;
  final TextStyle s16;
  final TextStyle s14;
  final TextStyle s12;
  final TextStyle s10;

  const AppTypography({
    required this.s24,
    required this.s18,
    required this.s16,
    required this.s14,
    required this.s12,
    required this.s10,
  });

  factory AppTypography.fromTextTheme(TextTheme t) => AppTypography(
    s24: t.headlineSmall ?? const TextStyle(fontSize: 24),
    s18: t.titleMedium ?? const TextStyle(fontSize: 18),
    s16: t.bodyLarge ?? const TextStyle(fontSize: 16),
    s14: t.bodyMedium ?? const TextStyle(fontSize: 14),
    s12: t.labelMedium ?? const TextStyle(fontSize: 12),
    s10: t.labelSmall ?? const TextStyle(fontSize: 10),
  );

  TextStyle style(
    BuildContext context, {
    required AppTextSize size,
    AppTextWeight weight = AppTextWeight.regular,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final base = _baseFor(size);
    final fw = _mapWeight(weight);
    // Use GoogleFonts here:
    return GoogleFonts.plusJakartaSans(
      textStyle: base.copyWith(fontWeight: fw, color: color),
    );
  }

  TextStyle _baseFor(AppTextSize size) {
    switch (size) {
      case AppTextSize.s24:
        return s24;
      case AppTextSize.s18:
        return s18;
      case AppTextSize.s16:
        return s16;
      case AppTextSize.s14:
        return s14;
      case AppTextSize.s12:
        return s12;
      case AppTextSize.s10:
      default:
        return s10;
    }
  }

  @override
  AppTypography copyWith({
    TextStyle? s24,
    TextStyle? s18,
    TextStyle? s16,
    TextStyle? s14,
    TextStyle? s12,
    TextStyle? s10,
  }) => AppTypography(
    s24: s24 ?? this.s24,
    s18: s18 ?? this.s18,
    s16: s16 ?? this.s16,
    s14: s14 ?? this.s14,
    s12: s12 ?? this.s12,
    s10: s10 ?? this.s10,
  );

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      s24: TextStyle.lerp(s24, other.s24, t)!,
      s18: TextStyle.lerp(s18, other.s18, t)!,
      s16: TextStyle.lerp(s16, other.s16, t)!,
      s14: TextStyle.lerp(s14, other.s14, t)!,
      s12: TextStyle.lerp(s12, other.s12, t)!,
      s10: TextStyle.lerp(s10, other.s10, t)!,
    );
  }
}
