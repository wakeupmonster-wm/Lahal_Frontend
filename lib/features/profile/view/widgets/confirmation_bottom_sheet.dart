import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/app_button.dart';

import 'package:lahal_application/utils/components/bottom_sheets/animated_bottom_sheet.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final AppButtonVariant confirmVariant;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    required this.onConfirm,
    this.confirmVariant = AppButtonVariant.danger,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String confirmLabel,
    required VoidCallback onConfirm,
    AppButtonVariant confirmVariant = AppButtonVariant.danger,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationBottomSheet(
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        confirmVariant: confirmVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;

    return AppAnimatedBottomSheet(
      children: [
        // Title
        Center(
          child: AppText(
            title,
            size: AppTextSize.s18,
            weight: AppTextWeight.bold,
            color: tx.neutral,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: tok.gap.md),

        // Message
        Center(
          child: AppText(
            subtitle,
            size: AppTextSize.s14,
            color: tx.subtle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: tok.gap.xl),

        // Buttons
        Column(
          children: [
            AppButton(
              radiusOverride: 12,
              label: confirmLabel,
              onPressed: onConfirm,
              minWidth: double.infinity,
              variant: confirmVariant,
            ),
            SizedBox(height: tok.gap.sm),
            AppButton(
              radiusOverride: 12,
              label: AppStrings.cancel,
              onPressed: () => context.pop(),
              variant: AppButtonVariant.ghost,
              minWidth: double.infinity,
              fgColorOverride: tx.subtle,
            ),
          ],
        ),
        SizedBox(height: tok.gap.sm),
      ],
    );
  }
}
