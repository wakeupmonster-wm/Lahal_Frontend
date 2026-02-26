import 'package:flutter/material.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onManualSearch;

  const LocationPermissionDialog({
    super.key,
    required this.onEnable,
    required this.onManualSearch,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onEnable,
    required VoidCallback onManualSearch,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Force them to choose an option ideally
      builder: (context) => LocationPermissionDialog(
        onEnable: onEnable,
        onManualSearch: onManualSearch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tok.radiusLg * 1.5),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tok.gap.lg,
          vertical: tok.gap.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            Image.asset(
              AppAssets.locationPermissionImage,
              height: 120,
              fit: BoxFit.contain,
            ),
            SizedBox(height: tok.gap.lg),

            // Title
            AppText(
              "Location permission is off",
              size: AppTextSize.s18,
              weight: AppTextWeight.bold,
              color: tx.neutral,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tok.gap.sm),

            // Subtitle
            AppText(
              "Enable your location permission for a better\napp experience",
              size: AppTextSize.s14,
              weight: AppTextWeight.regular,
              color: tx.subtle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tok.gap.xl),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: "Enable location permission",
                onPressed: () {
                  Navigator.pop(context);
                  onEnable();
                },
                radiusOverride: tok.radiusMd,
                bgColorOverride: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: tok.gap.md),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onManualSearch();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: tok.gap.xs),
                child: AppText(
                  "Search location manually",
                  size: AppTextSize.s16,
                  weight: AppTextWeight.bold,
                  color: AppColor.primaryColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
