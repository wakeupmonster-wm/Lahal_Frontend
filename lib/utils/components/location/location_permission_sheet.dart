import 'package:flutter/material.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class LocationPermissionSheet extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onManualSearch;

  const LocationPermissionSheet({
    super.key,
    required this.onEnable,
    required this.onManualSearch,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onEnable,
    required VoidCallback onManualSearch,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPermissionSheet(
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
    final mediaQuery = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(tok.radiusLg * 1.5),
          topRight: Radius.circular(tok.radiusLg * 1.5),
        ),
      ),
      padding: EdgeInsets.only(
        left: tok.gap.lg,
        right: tok.gap.lg,
        top: tok.gap.md,
        bottom: tok.gap.lg + mediaQuery.padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: tok.gap.md),

          // Illustration
          Image.asset(
            AppAssets.locationPermissionImage,
            height: 150,
            fit: BoxFit.contain,
          ),

          SizedBox(height: tok.gap.lg),

          AppText(
            "Location permission is off",
            size: AppTextSize.s18,
            weight: AppTextWeight.bold,
            color: tx.neutral,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: tok.gap.xs),

          // Subtitle
          AppText(
            "Enable your location permission for a better app experience",
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
              radiusOverride: tok.gap.xs,
              bgColorOverride: AppColor.primaryColor,
            ),
          ),

          SizedBox(height: tok.gap.md),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onManualSearch();
            },
            child: AppText(
              "Search location manually",
              size: AppTextSize.s16,
              weight: AppTextWeight.bold,
              color: AppColor.primaryColor,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
