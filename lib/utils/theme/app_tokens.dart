import 'dart:ui';
import 'package:flutter/material.dart';

/// Semantic spacing buckets so your widgets never do math.
/// - `gap`  = space BETWEEN elements (e.g., between two buttons).
/// - `inset`= padding INSIDE containers (e.g., inside a Card/TextField).
/// - `screen` margins (outside containers).
/// All values are resolved (already scaled for the ßdevice).
@immutable
class AppGaps {
  final double xxs; // 8–10
  final double xs; // 12-14
  final double sm; // 16-20
  final double md; // 20-24
  final double lg; // 24-28
  final double xl; // 28-32
  final double xxl; // 32-36

  const AppGaps({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  AppGaps lerp(AppGaps other, double t) => AppGaps(
    xxs: lerpDouble(xxs, other.xxs, t)!,
    xs: lerpDouble(xs, other.xs, t)!,
    sm: lerpDouble(sm, other.sm, t)!,
    md: lerpDouble(md, other.md, t)!,
    lg: lerpDouble(lg, other.lg, t)!,
    xl: lerpDouble(xl, other.xl, t)!,
    xxl: lerpDouble(xxl, other.xxl, t)!,
  );
}

@immutable
class AppInsets {
  /// Screen margins (outside containers, e.g., page padding)
  final double screenH; // horizontal page padding (16)
  final double screenV; // vertical page padding (16)

  /// Common container paddings
  final double card; // inside a Card/Sheet (16)
  final double section; // section blocks (20)
  final double listItem; // ListTile-ish rows (16)

  /// TextField content paddings
  final double fieldH; // horizontal (16)
  final double fieldV; // vertical (14)

  const AppInsets({
    required this.screenH,
    required this.screenV,
    required this.card,
    required this.section,
    required this.listItem,
    required this.fieldH,
    required this.fieldV,
  });

  AppInsets lerp(AppInsets other, double t) => AppInsets(
    screenH: lerpDouble(screenH, other.screenH, t)!,
    screenV: lerpDouble(screenV, other.screenV, t)!,
    card: lerpDouble(card, other.card, t)!,
    section: lerpDouble(section, other.section, t)!,
    listItem: lerpDouble(listItem, other.listItem, t)!,
    fieldH: lerpDouble(fieldH, other.fieldH, t)!,
    fieldV: lerpDouble(fieldV, other.fieldV, t)!,
  );
}

/// ThemeExtension that carries ALL your tokens (resolved/scaled).
class AppTokens extends ThemeExtension<AppTokens> {
  // Spacing
  final AppGaps gap;
  final AppInsets inset;

  // Radii
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;

  // Icons
  final double iconSm; // 20
  final double iconLg; // 24

  // Component sizes
  final double appBarHeight;
  final double divider;
  final double cardElevation;

  const AppTokens({
    required this.gap,
    required this.inset,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.iconSm,
    required this.iconLg,
    required this.appBarHeight,
    required this.divider,
    required this.cardElevation,
  });

  @override
  AppTokens copyWith({
    AppGaps? gap,
    AppInsets? inset,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? iconSm,
    double? iconLg,
    double? appBarHeight,
    double? divider,
    double? cardElevation,
  }) {
    return AppTokens(
      gap: gap ?? this.gap,
      inset: inset ?? this.inset,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      iconSm: iconSm ?? this.iconSm,
      iconLg: iconLg ?? this.iconLg,
      appBarHeight: appBarHeight ?? this.appBarHeight,
      divider: divider ?? this.divider,
      cardElevation: cardElevation ?? this.cardElevation,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      gap: gap.lerp(other.gap, t),
      inset: inset.lerp(other.inset, t),
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
      iconSm: lerpDouble(iconSm, other.iconSm, t)!,
      iconLg: lerpDouble(iconLg, other.iconLg, t)!,
      appBarHeight: lerpDouble(appBarHeight, other.appBarHeight, t)!,
      divider: lerpDouble(divider, other.divider, t)!,
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t)!,
    );
  }

  // -------------------------------
  // FACTORY: create responsive tokens
  // -------------------------------
  /// Build a responsive set of tokens from screen width.
  /// - `designWidth` is your Figma base (430).
  /// - We clamp scale to [0.90, 1.20] to stay sane on tiny/huge screens.
  static AppTokens fromWidth({
    required double width,
    double designWidth = 430,
  }) {
    final wScale = (width / designWidth).clamp(0.90, 1.20);

    // Helper that linearly scales a base value within clamp
    double s(num base) => (base * wScale).toDouble();

    // Spacing: choose clear bases for 430px; everything scales from there.
    final gaps = AppGaps(
      xxs: s(8), // very tight
      xs: s(12),
      sm: s(16),
      md: s(20),
      lg: s(24),
      xl: s(28), // generous
      xxl: s(32), // extra generous
    );

    final insets = AppInsets(
      screenH: s(16), // page horizontal padding
      screenV: s(16), // page vertical padding
      card: s(16), // padding inside Card
      section: s(20),
      listItem: s(16),
      fieldH: s(16), // TextField content padding
      fieldV: s(14),
    );

    return AppTokens(
      gap: gaps,
      inset: insets,
      radiusSm: s(8),
      radiusMd: s(12),
      radiusLg: s(16),
      iconSm: 20, // fixed by design (you asked for 20 & 24)
      iconLg: 24,
      appBarHeight: s(56), // roughly 60 @ 430 previsouly 60
      divider: 1,
      cardElevation: 2,
    );
  }
}

/// Convenience accessors
extension AppTokensX on BuildContext {
  AppTokens get tok => Theme.of(this).extension<AppTokens>()!;
  AppGaps get gap => tok.gap;
  AppInsets get inset => tok.inset;
}
