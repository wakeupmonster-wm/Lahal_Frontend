import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

/// Shown on the Home Screen when no location has been obtained.
/// Prompts the user to grant location permission.
/// If permission is permanently denied, the button opens app settings.
class NoLocationWidget extends StatelessWidget {
  final LocationController locationController;

  const NoLocationWidget({
    super.key,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: tok.gap.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing location icon container
            _AnimatedLocationIcon(),

            SizedBox(height: tok.gap.xl),

            AppText(
              'Location not enabled',
              size: AppTextSize.s18,
              weight: AppTextWeight.bold,
              color: tx.neutral,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: tok.gap.sm),

            AppText(
              'Enable your location to discover nearby restaurants, get accurate delivery times, and find the best spots around you.',
              size: AppTextSize.s14,
              weight: AppTextWeight.regular,
              color: tx.subtle,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: tok.gap.xxl),

            // Action button — adapts based on loading state
            Obx(() {
              final isLoading = locationController.isLocationLoading.value;

              return SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Enable Location',
                  loading: isLoading,
                  bgColorOverride: AppColor.primaryColor,
                  leading: isLoading
                      ? null
                      : const Icon(Icons.location_on_rounded, color: Colors.white),
                  onPressed: isLoading
                      ? null
                      : () => locationController.enableLocation(context),
                ),
              );
            }),

            SizedBox(height: tok.gap.md),

            // Hint text for permanently blocked state
            AppText(
              'If the button doesn\'t work, your location permission may be blocked. Tapping will open app settings.',
              size: AppTextSize.s12,
              weight: AppTextWeight.regular,
              color: tx.subtle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A subtle animated icon to draw attention to the "no location" state.
class _AnimatedLocationIcon extends StatefulWidget {
  const _AnimatedLocationIcon();

  @override
  State<_AnimatedLocationIcon> createState() => _AnimatedLocationIconState();
}

class _AnimatedLocationIconState extends State<_AnimatedLocationIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.primaryColor.withOpacity(0.08),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primaryColor.withOpacity(0.12),
            ),
            child: Center(
              child: Icon(
                Icons.location_off_rounded,
                size: 40,
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
