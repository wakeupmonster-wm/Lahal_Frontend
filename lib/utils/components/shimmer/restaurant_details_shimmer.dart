import 'package:flutter/material.dart';
import 'package:lahal_application/utils/components/shimmer/app_shimmer_effect.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';

class RestaurantDetailsShimmer extends StatelessWidget {
  const RestaurantDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image Shimmer
          AppShimerEffect(
            width: double.infinity,
            height: height * 0.45,
            radius: 0,
          ),
          
          Padding(
            padding: EdgeInsets.all(tok.gap.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Halal Summary Title
                AppShimerEffect(width: width * 0.4, height: 20, radius: tok.radiusSm),
                SizedBox(height: tok.gap.md),
                
                // Halal Summary Text Lines
                AppShimerEffect(width: double.infinity, height: 14, radius: tok.radiusSm),
                const SizedBox(height: 8),
                AppShimerEffect(width: width * 0.8, height: 14, radius: tok.radiusSm),
                const SizedBox(height: 8),
                AppShimerEffect(width: width * 0.6, height: 14, radius: tok.radiusSm),
                
                SizedBox(height: tok.gap.md),
                
                // Tags
                Row(
                  children: [
                    AppShimerEffect(width: 80, height: 32, radius: tok.radiusSm),
                    SizedBox(width: tok.gap.sm),
                    AppShimerEffect(width: 100, height: 32, radius: tok.radiusSm),
                    SizedBox(width: tok.gap.sm),
                    AppShimerEffect(width: 60, height: 32, radius: tok.radiusSm),
                  ],
                ),
                
                SizedBox(height: tok.gap.xl),
                
                // Photos Title
                AppShimerEffect(width: width * 0.25, height: 20, radius: tok.radiusSm),
                SizedBox(height: tok.gap.md),
                
                // Photos Grid Shimmer
                SizedBox(
                  height: height * 0.268,
                  child: Row(
                    children: [
                      // Big Image Left
                      Expanded(
                        flex: 2,
                        child: AppShimerEffect(width: double.infinity, height: double.infinity, radius: tok.radiusMd),
                      ),
                      SizedBox(width: tok.gap.sm),
                      // Two small images right
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(child: AppShimerEffect(width: double.infinity, height: double.infinity, radius: tok.radiusMd)),
                            SizedBox(height: tok.gap.sm),
                            Expanded(child: AppShimerEffect(width: double.infinity, height: double.infinity, radius: tok.radiusMd)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tok.gap.sm),
                // Bottom row photos
                SizedBox(
                  height: height * 0.128,
                  child: Row(
                    children: [
                      Expanded(child: AppShimerEffect(width: double.infinity, height: double.infinity, radius: tok.radiusMd)),
                      SizedBox(width: tok.gap.sm),
                      Expanded(child: AppShimerEffect(width: double.infinity, height: double.infinity, radius: tok.radiusMd)),
                      SizedBox(width: tok.gap.sm),
                      Expanded(child: AppShimerEffect(width: double.infinity, height: double.infinity, radius: tok.radiusMd)),
                    ],
                  ),
                ),
                
                SizedBox(height: tok.gap.xl),
                // Just enough to push anything else off-screen
              ],
            ),
          )
        ],
      ),
    );
  }
}
