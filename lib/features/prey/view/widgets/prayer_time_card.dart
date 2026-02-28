import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lahal_application/features/prey/model/prayer_time_model.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTimeModel prayerTime;

  const PrayerTimeCard({super.key, required this.prayerTime});

  Widget _getIconForPrayer(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
      case 'fazar':
        return const Icon(
          CupertinoIcons.cloud_sun_fill,
          color: Colors.orange,
          size: 28,
        );
      case 'sunrise':
      case 'dhuhr':
        return const Icon(
          CupertinoIcons.sun_max_fill,
          color: Colors.orange,
          size: 28,
        );
      case 'asr':
        return const Icon(
          CupertinoIcons.cloud_sun_fill,
          color: Colors.orange,
          size: 28,
        );
      case 'magrib':
        return const Icon(
          CupertinoIcons.moon_fill,
          color: Colors.deepOrangeAccent,
          size: 28,
        );
      case 'isha':
        return const Icon(
          CupertinoIcons.moon_stars_fill,
          color: Colors.deepOrangeAccent,
          size: 28,
        );
      default:
        return const Icon(
          CupertinoIcons.sun_max_fill,
          color: Colors.orange,
          size: 28,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;

    return Container(
      width: 100, // Fixed width for horizontal scroll
      margin: EdgeInsets.only(right: tok.gap.md),
      padding: EdgeInsets.symmetric(
        vertical: tok.gap.md,
        horizontal: tok.gap.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1).withOpacity(0.4), // Very light mint
        borderRadius: BorderRadius.circular(tok.radiusMd * 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getIconForPrayer(prayerTime.name),
          const SizedBox(height: 6),
          AppText(prayerTime.name, size: AppTextSize.s14, color: tx.neutral),
          const SizedBox(height: 2),
          AppText(
            prayerTime.time,
            size: AppTextSize.s16,
            weight: AppTextWeight.bold,
            color: tx.neutral,
          ),
        ],
      ),
    );
  }
}
