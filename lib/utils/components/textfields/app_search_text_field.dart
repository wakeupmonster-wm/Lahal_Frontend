import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

/// Reusable Search Field
/// - Uses muted hint + icon color
/// - Outline border (colorScheme.outline)
/// - No label, pure search UX
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tc = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final tp = Theme.of(context).extension<AppTypography>()!;

    final Color textColor = tc.neutral;
    const Color hintColor = AppPalette.textMuted; // muted
    const Color iconColor = AppPalette.textMuted; // muted icon
    final Color outlineColor = cs.outline.withValues(alpha: 0.3);
    final Color enabledBorderColor = cs.primary;

    final radius = tok.radiusMd;

    final textStyle = tp.style(
      context,
      size: AppTextSize.s16,
      weight: AppTextWeight.medium,
      color: textColor,
    );

    final hintStyle = tp.style(
      context,
      size: AppTextSize.s16,
      weight: AppTextWeight.medium,
      color: hintColor,
    );

    return TextField(
      controller: controller,
      style: textStyle,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tok.inset.section,
          vertical: tok.inset.section,
        ),
        hintText: hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: tok.gap.md, right: tok.gap.xxs),
          child: Icon(
            Iconsax.search_normal_1_outline,
            size: tok.iconSm,
            color: iconColor,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: tok.iconLg + tok.gap.sm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: enabledBorderColor, width: 1.5),
        ),
      ),
    );
  }
}
