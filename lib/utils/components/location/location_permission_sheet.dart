import 'package:flutter/material.dart';
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
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(tok.gap.xxs),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.close, size: 20, color: tx.subtle),
              ),
            ),
          ),

          SizedBox(height: tok.gap.md),

          // Illustration
          // Note: Using a placeholder container since I don't have the exact illustration SVG
          Container(
            height: 150,
            width: double.infinity,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Generic cloud/background shape
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: tx.neutral.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                // Location icon with slash/stop
                const Icon(
                  Icons.location_off_outlined,
                  size: 60,
                  color: Colors.redAccent,
                ),
              ],
            ),
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
