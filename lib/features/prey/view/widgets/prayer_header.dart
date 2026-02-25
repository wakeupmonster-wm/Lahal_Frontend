import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/prey/controller/prayer_controller.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class PrayerHeader extends StatelessWidget {
  const PrayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrayerController>();
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 350, // Approximate height for header
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            cs.primaryContainer.withOpacity(0.5), // Light teal at top
            cs.surface, // Background colored bottom
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Clock Time
          Obx(
            () => AppText(
              controller.currentTime.value,
              size: AppTextSize.s24,
              weight: AppTextWeight.bold,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 10),
          // Location Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tok.gap.sm,
              vertical: tok.gap.xxs,
            ),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 16, color: cs.primary),
                const SizedBox(width: 4),
                Obx(
                  () => AppText(
                    controller.currentLocation.value,
                    size: AppTextSize.s12,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Mosque Background
          SvgPicture.asset(
            AppSvg.mosqueImage,
            width: double.infinity,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              cs.primary.withOpacity(0.1),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
