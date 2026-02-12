import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/home_controller.dart';
import 'package:lahal_application/features/home/view/widgets/category_header_delegate.dart';
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

    // Responsive heights
    final expandedHeight = 230.0;
    final collapsedHeight = kToolbarHeight + 20; // Search bar + padding

    return Scaffold(
      backgroundColor: cs.surface,
      body: RefreshIndicator(
        onRefresh: () => controller.getBestRestaurants(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // --- 1. Expandable Header with Search Bar ---
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              backgroundColor: cs.surface,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Green Background Image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(tok.radiusLg * 2),
                        bottomRight: Radius.circular(tok.radiusLg * 2),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.homeBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Content over background (Logo, Location)
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(
                  30,
                ), // Height of search bar area
                child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(
                    horizontal: tok.gap.lg,
                    vertical: tok.gap.xs,
                  ),
                  alignment: Alignment.center,
                  child: Row(
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
                ),
              ),
            ),

            // --- 2. Sticky Categories ---
            SliverPersistentHeader(
              pinned: true,
              delegate: CategoryHeaderDelegate(
                height: 130, // Height for category row + padding
                backgroundColor: cs.surface,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: tok.gap.md,
                    vertical: tok.gap.sm,
                  ),
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
              ),
            ),

            // --- 3. Best Restaurants Title ---
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tok.gap.lg,
                  vertical: tok.gap.md,
                ),
                child: AppText(
                  'Best restaurants',
                  size: AppTextSize.s18,
                  weight: AppTextWeight.bold,
                  color: tx.neutral,
                ),
              ),
            ),

            // --- 4. Restaurant List ---
            Obx(() {
              if (controller.isLoading.value) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: tok.gap.lg,
                        vertical: tok.gap.xs,
                      ),
                      child: const RestaurantCardShimmer(),
                    ),
                    childCount: 3,
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.bestRestaurants.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: WarningDisplay(
                    warningMessage: "Something went wrong",
                    subWarningMessage: controller.errorMessage.value,
                    onRetry: () => controller.getBestRestaurants(),
                  ),
                );
              }

              if (controller.bestRestaurants.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    title: "No Restaurants Found",
                    description:
                        "We couldn't find any restaurants in your area.",
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final restaurant = controller.bestRestaurants[index];
                    return RestaurantCard(
                      restaurant: restaurant,
                      onTap: () {
                        context.push(AppRoutes.restaurantDetails);
                      },
                    );
                  }, childCount: controller.bestRestaurants.length),
                ),
              );
            }),

            SliverToBoxAdapter(child: SizedBox(height: tok.gap.xxl)),
          ],
        ),
      ),
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
        mainAxisSize:
            MainAxisSize.min, // Important for layout inside row/column
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
