import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lahal_application/features/prey/controller/prayer_controller.dart';
import 'package:lahal_application/features/prey/view/widgets/prayer_header.dart';
import 'package:lahal_application/features/prey/view/widgets/upcoming_prayer_card.dart';
import 'package:lahal_application/features/prey/view/widgets/prayer_time_card.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';

import 'package:lahal_application/features/home/view/widgets/no_location_widget.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(PrayerController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;

    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Obx(() {
        final loc = controller.locationController;
        final bool popupWasShown = !loc.shouldShowLocationPopup();
        final bool noLocation =
            !loc.hasLocation.value &&
            !loc.isLocationLoading.value &&
            (loc.locationDenied.value || popupWasShown);

        if (noLocation) {
          return NoLocationWidget(locationController: loc);
        }

        if (loc.isLocationLoading.value && !loc.hasLocation.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PrayerHeader().animate().fadeIn().slideY(
                begin: -0.1,
                end: 0,
              ),
              SizedBox(height: tok.gap.sm),

              const UpcomingPrayerCard()
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .scale(begin: const Offset(0.95, 0.95)),
              // 3. Prayer Times Title
              SizedBox(height: tok.gap.xxl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
                child: AppText(
                  AppStrings.prayerTimesTitle,
                  size: AppTextSize.s18,
                  weight: AppTextWeight.bold,
                  color: tx.primary,
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),

              SizedBox(height: tok.gap.xl),

              // 4. Horizontal Prayer Times List
              SizedBox(
                height: height * 0.148,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: tok.gap.lg),
                    itemCount: controller.prayerTimes.length,
                    itemBuilder: (context, index) {
                      return PrayerTimeCard(
                            prayerTime: controller.prayerTimes[index],
                          )
                          .animate()
                          .fadeIn(delay: (500 + index * 100).ms)
                          .slideX(begin: 0.1, end: 0);
                    },
                  );
                }),
              ),
              SizedBox(height: tok.gap.lg * 6),
            ],
          ),
        );
      }),
    );
  }
}
