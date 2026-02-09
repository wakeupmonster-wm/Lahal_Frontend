import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/app_button.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tok.radiusLg),
      ),
      backgroundColor: cs.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tok.gap.lg,
          vertical: tok.gap.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              AppStrings.wantToLogout,
              size: AppTextSize.s18,
              weight: AppTextWeight.bold,
              color: tx.neutral,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tok.gap.md),
            AppText(
              AppStrings.logoutConfirmation,
              size: AppTextSize.s14,
              color: tx.subtle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tok.gap.xl),
            AppButton(
              label: AppStrings.logout,
              onPressed: onConfirm,
              variant: AppButtonVariant.danger,
              minWidth: double.infinity,
            ),
            SizedBox(height: tok.gap.sm),
            AppButton(
              label: AppStrings.cancel,
              onPressed: () => context.pop(),
              variant: AppButtonVariant.ghost,
              minWidth: double.infinity,
              fgColorOverride: tx.subtle,
            ),
          ],
        ),
      ),
    );
  }
}
