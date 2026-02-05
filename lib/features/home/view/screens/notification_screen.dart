import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/features/home/controller/notification_controller.dart';
import 'package:lahal_application/features/home/model/notification_model.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.notification,
        centerTitle: false,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer(tok, cs, tx);
        }

        if (controller.notifications.isEmpty) {
          return const EmptyStateWidget(
            imagePath: AppAssets.emptyStateImage,
            title: 'No notifications yet',
            description: 'We will notify you when something important happens.',
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(tok.gap.md),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => SizedBox(height: tok.gap.md),
          itemBuilder: (context, index) {
            return _buildNotificationItem(
              tok,
              tx,
              cs,
              controller.notifications[index],
            );
          },
        );
      }),
    );
  }

  Widget _buildNotificationItem(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    NotificationModel notification,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(tok.gap.sm),
          decoration: BoxDecoration(
            color: cs.surface,
            shape: BoxShape.circle,
            border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          ),
          child: Icon(
            notification.type == 'star'
                ? Iconsax.star_outline
                : Iconsax.notification_outline,
            color: tx.neutral,
            size: tok.gap.lg,
          ),
        ),
        SizedBox(width: tok.gap.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                notification.title,
                size: AppTextSize.s16,
                weight: AppTextWeight.bold,
                color: tx.neutral,
              ),
              SizedBox(height: tok.gap.xs),
              AppText(
                notification.description,
                size: AppTextSize.s14,
                color: tx.subtle,
              ),
              SizedBox(height: tok.gap.xs),
              AppText(
                notification.time,
                size: AppTextSize.s12,
                color: tx.muted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(AppTokens tok, ColorScheme cs, AppTextColors tx) {
    return ListView.separated(
      padding: EdgeInsets.all(tok.gap.lg),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: tok.gap.md),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: cs.outlineVariant.withOpacity(0.9),
          highlightColor: cs.outlineVariant.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: tok.radiusLg * 4,
                height: tok.radiusLg * 4,
                decoration: BoxDecoration(
                  color: cs.surface,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: tok.gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: tok.gap.md,
                      color: cs.surface,
                    ),
                    SizedBox(height: tok.gap.xs),
                    Container(
                      width: tok.gap.lg * 4,
                      height: tok.gap.md,
                      color: cs.surface,
                    ),
                    SizedBox(height: tok.gap.xs),
                    Container(
                      width: tok.gap.lg * 4,
                      height: tok.gap.sm,
                      color: cs.surface,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
