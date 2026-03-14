import 'package:flutter/material.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

import 'package:lahal_application/utils/components/bottom_sheets/animated_bottom_sheet.dart';

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

    return AppAnimatedBottomSheet(
      children: [
        SizedBox(height: tok.gap.md),

        // Illustration
        Center(
          child: Image.asset(
            AppAssets.locationPermissionImage,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: tok.gap.lg),

        Center(
          child: AppText(
            "Find restaurants near you",
            size: AppTextSize.s18,
            weight: AppTextWeight.bold,
            color: tx.neutral,
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: tok.gap.xs),

        // Subtitle
        Center(
          child: AppText(
            "Turn on location to discover nearby restaurants and get faster delivery options.",
            size: AppTextSize.s14,
            weight: AppTextWeight.regular,
            color: tx.subtle,
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: tok.gap.xl),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: "Fetch current location",
            onPressed: () {
              Navigator.pop(context);
              onEnable();
            },
            radiusOverride: tok.gap.xs,
            bgColorOverride: AppColor.primaryColor,
          ),
        ),

        SizedBox(height: tok.gap.md),

        Center(
          child: GestureDetector(
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
        ),
        SizedBox(height: tok.gap.lg),
      ],
    );
  }
}
