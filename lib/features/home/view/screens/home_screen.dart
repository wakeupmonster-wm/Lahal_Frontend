import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/home_controller.dart';
import 'package:lahal_application/utils/components/location/location_search_bar.dart';
import 'package:lahal_application/utils/components/shimmer/restaurant_card_shimmer.dart';
import 'package:lahal_application/utils/components/widgets/restaurant_card.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/components/widgets/warning_dispaly.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/features/home/view/widgets/filter_bottom_sheet.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.getBestRestaurants(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      height: 275,
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
                                child: LocationSearchBar(
                                  controller: TextEditingController(),
                                  onChanged: (value) {},
                                  hintText: AppStrings.searchLocationHint,
                                ),
                              ),

                              SizedBox(width: tok.gap.md),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => FilterBottomSheet.show(context),
                                child: Padding(
                                  padding: EdgeInsets.all(tok.gap.xs),
                                  child: SvgPicture.asset(AppSvg.filterIcon),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: tok.gap.lg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // --- Category Section ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tok.gap.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  return _buildShimmer(tok);
                }

                if (controller.errorMessage.isNotEmpty &&
                    controller.bestRestaurants.isEmpty) {
                  return WarningDisplay(
                    warningMessage: "Something went wrong",
                    subWarningMessage: controller.errorMessage.value,
                    onRetry: () => controller.getBestRestaurants(),
                  );
                }

                if (controller.bestRestaurants.isEmpty) {
                  return const EmptyStateWidget(
                    title: "No Restaurants Found",
                    description:
                        "We couldn't find any restaurants in your area.",
                  );
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
              SizedBox(height: tok.gap.lg),
              SizedBox(height: tok.gap.lg),
              SizedBox(height: tok.gap.lg),

              SizedBox(height: tok.gap.lg), SizedBox(height: tok.gap.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(AppTokens tok) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const RestaurantCardShimmer();
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
      padding: EdgeInsets.only(right: tok.gap.sm),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(tok.gap.xs),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.9),
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
