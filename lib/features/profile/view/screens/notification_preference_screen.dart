import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/controller/notification_preference_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class NotificationPreferenceScreen extends StatelessWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationPreferenceController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.notificationPreferences,
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            SizedBox(height: tok.gap.md),
            _buildPreferenceItem(
              context,
              AppStrings.offersAndPromotions,
              controller.offersEnabled.value,
              controller.toggleOffers,
            ),
            _buildDivider(cs),
            _buildPreferenceItem(
              context,
              AppStrings.prayerTimeAlerts,
              controller.prayerAlertsEnabled.value,
              controller.togglePrayerAlerts,
            ),
            _buildDivider(cs),
            _buildPreferenceItem(
              context,
              AppStrings.reviewAndUpdateAlerts,
              controller.reviewUpdatesEnabled.value,
              controller.toggleReviewUpdates,
            ),
            _buildDivider(cs),
          ],
        );
      }),
    );
  }

  Widget _buildPreferenceItem(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tok.gap.lg,
        vertical: tok.gap.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppText(
              title,
              size: AppTextSize.s16,
              weight: AppTextWeight.medium,
              color: tx.primary,
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: cs.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: cs.outlineVariant.withOpacity(0.5), thickness: 0.8),
    );
  }
}
