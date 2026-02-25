import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/prey/controller/prayer_controller.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class UpcomingPrayerCard extends StatelessWidget {
  const UpcomingPrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrayerController>();
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
      child: Container(
        padding: EdgeInsets.all(tok.gap.lg),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(tok.radiusLg),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Upcoming prayer",
                  size: AppTextSize.s14,
                  color: tx.subtle,
                ),
                const SizedBox(height: 4),
                Obx(
                  () => AppText(
                    controller.upcomingPrayer.value?.name ?? "N/A",
                    size: AppTextSize.s24,
                    weight: AppTextWeight.bold,
                    color: tx.primary,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  "Time remaining",
                  size: AppTextSize.s14,
                  color: tx.subtle,
                ),
                const SizedBox(height: 4),
                Obx(
                  () => AppText(
                    controller.timeRemaining.value,
                    size: AppTextSize.s24,
                    weight: AppTextWeight.bold,
                    color: tx.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
