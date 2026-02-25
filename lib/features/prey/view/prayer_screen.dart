import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/prey/controller/prayer_controller.dart';
import 'package:lahal_application/features/prey/view/widgets/prayer_header.dart';
import 'package:lahal_application/features/prey/view/widgets/upcoming_prayer_card.dart';
import 'package:lahal_application/features/prey/view/widgets/prayer_time_card.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(PrayerController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Clock, Location, Mosque SVG)
            const PrayerHeader(),

            // 2. Upcoming Prayer Card (Floating over header overlap)
            Transform.translate(
              offset: const Offset(0, -40),
              child: const UpcomingPrayerCard(),
            ),

            // 3. Prayer Times Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              child: AppText(
                "Prayer Times",
                size: AppTextSize.s18,
                weight: AppTextWeight.bold,
                color: tx.primary,
              ),
            ),

            const SizedBox(height: 20),

            // 4. Horizontal Prayer Times List
            SizedBox(
              height: 120,
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
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
