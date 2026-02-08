import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/home_controller.dart';
import 'package:lahal_application/utils/components/widgets/restaurant_card.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Green Curved Header ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(tok.radiusLg * 2),
                    bottomRight: Radius.circular(tok.radiusLg * 2),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.homeBackground,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tok.gap.lg,
                      vertical: tok.gap.sm,
                    ),
                    child: Column(
                      children: [
                        // Top Bar: Logo & Notification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppSvg.logoIcon,
                                  width: tok.gap.xl,
                                  height: tok.gap.xl,
                                  colorFilter: ColorFilter.mode(
                                    tx.inverse,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: tok.gap.xs),
                                AppText(
                                  'Lalah',
                                  size: AppTextSize.s24,
                                  weight: AppTextWeight.bold,
                                  color: tx.inverse,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.notificationScreen);
                              },
                              child: SvgPicture.asset(
                                AppSvg.notificaitonIcon,
                                // Assuming notification icon also needs to be inverse if it's on green
                                colorFilter: ColorFilter.mode(
                                  tx.inverse,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: tok.gap.md),

                        // Location Row
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: tx.inverse,
                              size: 18,
                            ),
                            SizedBox(width: tok.gap.xs),
                            AppText(
                              'Melbourne, Victoria (VIC)',
                              size: AppTextSize.s14,
                              weight: AppTextWeight.medium,
                              color: tx.inverse,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: tx.inverse,
                              size: 18,
                            ),
                          ],
                        ),
                        SizedBox(height: tok.gap.md),

                        // Search Bar & Filter
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: tok.inset.fieldH,
                                  vertical: tok.inset.fieldV / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.surface.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(
                                    tok.radiusMd,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: tx.subtle,
                                      size: 24,
                                    ),
                                    SizedBox(width: tok.gap.sm),
                                    Expanded(
                                      child: TextField(
                                        style: TextStyle(color: tx.neutral),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search for area, street name...',
                                          hintStyle: TextStyle(
                                            color: tx.subtle,
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: tok.gap.md),
                            SvgPicture.asset(
                              AppSvg.filterIcon,
                              colorFilter: ColorFilter.mode(
                                tx.inverse,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: tok.gap.lg),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- Category Section ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.md),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Near you',
                      AppAssets.mapIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Top rated',
                      AppAssets.thumbIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Open now',
                      AppAssets.clockIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Certified',
                      AppAssets.certifiedIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Top reviewed',
                      AppAssets.reviewIcon,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: tok.gap.md),

            // --- Best Restaurants Heading ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              child: AppText(
                'Best restaurants',
                size: AppTextSize.s18,
                weight: AppTextWeight.bold,
                color: tx.neutral,
              ),
            ),
            SizedBox(height: tok.gap.md),

            // --- Restaurant List ---
            Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerLoader(tok, cs);
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
                itemCount: controller.bestRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.bestRestaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      context.push(AppRoutes.restaurantDetails);
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoader(AppTokens tok, ColorScheme cs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: tok.gap.lg),
          height: 280,
          decoration: BoxDecoration(
            color: cs.outlineVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(tok.radiusLg),
          ),
          child: Shimmer.fromColors(
            baseColor: cs.outlineVariant.withOpacity(0.3),
            highlightColor: cs.outlineVariant.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(tok.radiusLg),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    String label,
    String iconPath,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: tok.gap.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(tok.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: cs.onSurface.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              iconPath,
              width: tok.gap.xxl,
              height: tok.gap.xxl,
            ),
          ),
          SizedBox(height: tok.gap.xs),
          AppText(
            label,
            size: AppTextSize.s12,
            weight: AppTextWeight.medium,
            color: tx.subtle,
          ),
        ],
      ),
    );
  }
}
