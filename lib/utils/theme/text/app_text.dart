// =============================
// Tiny wrapper to request size+weight+token color consistently
// =============================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_typography.dart';
import 'app_text_color.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.size = AppTextSize.s16,
    this.weight = AppTextWeight.regular,
    this.colorToken, // when null, uses neutral
    this.color, // hard override if needed
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDecoration,
  });

  final String data;
  final AppTextSize size;
  final AppTextWeight weight;
  final Color? color; // absolute override
  final Color? colorToken; // supply from AppTextColors (e.g., c.primary)
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    final tp = Theme.of(context).extension<AppTypography>()!;
    final tc = Theme.of(context).extension<AppTextColors>()!;
    final resolved = color ?? colorToken ?? tc.neutral;
    final baseStyle = tp.style(
      context,
      size: size,
      weight: weight,
      color: resolved,
    );

    // Wrap/merge using GoogleFonts to ensure correct fontFamily + weight resolution
    final finalStyle = GoogleFonts.urbanist(textStyle: baseStyle);

    // optional: if you want to enforce weight even more explicitly
    // final finalStyle = GoogleFonts.plusJakartaSans(textStyle: baseStyle.copyWith(fontWeight: _mapWeight(weight)));

    return Text(
      data,
      style: finalStyle.copyWith(decoration: textDecoration),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
