import 'package:flutter/material.dart';
import 'package:lahal_application/features/prey/model/prayer_time_model.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTimeModel prayerTime;

  const PrayerTimeCard({super.key, required this.prayerTime});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 100, // Fixed width for horizontal scroll
      margin: EdgeInsets.only(right: tok.gap.md),
      padding: EdgeInsets.symmetric(
        vertical: tok.gap.md,
        horizontal: tok.gap.sm,
      ),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.5), // Themed light teal
        borderRadius: BorderRadius.circular(tok.radiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(prayerTime.time, size: AppTextSize.s14, color: tx.subtle),
          const SizedBox(height: 8),
          AppText(
            prayerTime.name,
            size: AppTextSize.s16,
            weight: AppTextWeight.bold,
            color: tx.primary,
          ),
        ],
      ),
    );
  }
}
