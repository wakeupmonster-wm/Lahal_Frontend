import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/components/shimmer/app_shimmer_effect.dart';

class RestaurantCardShimmer extends StatelessWidget {
  const RestaurantCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: tok.gap.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(tok.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Shimmer
          AppShimerEffect(
            height: 200,
            width: double.infinity,
            radius: tok.radiusLg,
          ),
          Padding(
            padding: EdgeInsets.all(tok.gap.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title Shimmer
                    const AppShimerEffect(height: 20, width: 150, radius: 4),
                    // Rating Shimmer
                    const AppShimerEffect(height: 24, width: 40, radius: 4),
                  ],
                ),
                SizedBox(height: tok.gap.xxs),
                // Address Shimmer
                const AppShimerEffect(height: 14, width: 200, radius: 4),
                SizedBox(height: tok.gap.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Distance Shimmer
                    const AppShimerEffect(height: 14, width: 100, radius: 4),
                    // Review Count Shimmer
                    const AppShimerEffect(height: 12, width: 60, radius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
