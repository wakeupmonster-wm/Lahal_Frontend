import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/features/home/controller/home_controller.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart';
import 'package:lahal_application/features/bottomNavigationBar/controller/bottom_navigationbar_controller.dart';
import 'package:lahal_application/features/home/view/widgets/category_header_delegate.dart';
import 'package:lahal_application/utils/components/location/location_permission_sheet.dart';
import 'package:lahal_application/utils/components/shimmer/restaurant_card_shimmer.dart';
import 'package:lahal_application/utils/components/textfields/app_animated_search_field.dart';
import 'package:lahal_application/utils/components/buttons/app_shimmer_fab.dart';
import 'package:lahal_application/utils/components/widgets/app_footer.dart';
import 'package:lahal_application/utils/components/widgets/restaurant_card.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/components/widgets/warning_dispaly.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/features/home/view/widgets/no_location_widget.dart';
import 'package:lahal_application/features/home/view/widgets/filter_bottom_sheet.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;
  late final LocationController locationController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    locationController = Get.put(LocationController());
    scrollController = ScrollController();

    scrollController.addListener(() {
      final bottomNavController = Get.find<BottomNavController>();
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        bottomNavController.setNavBarVisible(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        bottomNavController.setNavBarVisible(true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (locationController.shouldShowLocationPopup()) {
        _showLocationPopup();
      }
    });
  }

  void _showLocationPopup() {
    LocationPermissionSheet.show(
      context,
      onEnable: () async {
        await locationController.markLocationPopupAsShown();
        await locationController.enableLocation(context);
      },
      onManualSearch: () async {
        await locationController.markLocationPopupAsShown();
        if (mounted) {
          context.push(AppRoutes.changeLocationScreen);
        }
      },
    ).then((_) {
      // User dismissed the sheet without taking action — mark as denied
      if (!locationController.hasLocation.value &&
          !locationController.isLocationLoading.value) {
        locationController.locationDenied.value = true;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    // Responsive heights
    final expandedHeight = height * 0.225;
    final collapsedHeight = kToolbarHeight + 20; // Search bar + paddin
    return Scaffold(
      backgroundColor: cs.surface,
      body: RefreshIndicator(
        onRefresh: () => controller.getBestRestaurants(),
        child: CustomScrollView(
          controller: scrollController,
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
                        padding: EdgeInsets.all(tok.gap.xs),
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
                                  child: Container(
                                    padding: EdgeInsets.all(tok.gap.xs),
                                    decoration: BoxDecoration(
                                      color: cs.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      AppSvg.notificaitonNobackgroundIcon,
                                      width: tok.iconSm,
                                      height: tok.iconSm,
                                      colorFilter: ColorFilter.mode(
                                        tx.neutral,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: tok.gap.md),

                            // Location Row
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _showLocationPopup,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppSvg.locationNobcakgroundIcon,
                                    color: Colors.white,
                                  ),
                                  // Icon(
                                  //   Icons.location_on,
                                  //   color: tx.inverse,
                                  //   size: 18,
                                  // ),
                                  SizedBox(width: tok.gap.xxs),
                                  Obx(
                                    () => AppText(
                                      locationController.isLocationLoading.value
                                          ? "Fetching location..."
                                          : locationController
                                                .currentAddress
                                                .value,
                                      size: AppTextSize.s14,
                                      weight: AppTextWeight.medium,
                                      color: tx.inverse,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: tx.inverse,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(22),
                child: _HomeSearchBar(tok: tok, cs: cs, tx: tx),
              ),
            ),

            // --- 2. Sticky Categories + Restaurant List (only when location is available) ---
            Obx(() {
              // Show NoLocationWidget when: location is denied OR popup was shown but no location yet
              final bool popupWasShown = !locationController
                  .shouldShowLocationPopup();
              final bool noLocation =
                  !locationController.hasLocation.value &&
                  !locationController.isLocationLoading.value &&
                  (locationController.locationDenied.value || popupWasShown);

              if (noLocation) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: NoLocationWidget(
                    locationController: locationController,
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  // --- Sticky Categories ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: CategoryHeaderDelegate(
                      height: height * 0.145,
                      backgroundColor: cs.surface,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: tok.gap.xs,
                          // vertical: tok.gap.,
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCategoryItem(
                                tok,
                                tx,
                                cs,
                                'Near you',
                                AppAssets.mapIcon,
                                controller.selectedCategory.value == 'Near you',
                                () => controller.onCategorySelected('Near you'),
                              ),
                              _buildCategoryItem(
                                tok,
                                tx,
                                cs,
                                'Top rated',
                                AppAssets.thumbIcon,
                                controller.selectedCategory.value ==
                                    'Top rated',
                                () =>
                                    controller.onCategorySelected('Top rated'),
                              ),
                              _buildCategoryItem(
                                tok,
                                tx,
                                cs,
                                'Open now',
                                AppAssets.clockIcon,
                                controller.selectedCategory.value == 'Open now',
                                () => controller.onCategorySelected('Open now'),
                              ),
                              _buildCategoryItem(
                                tok,
                                tx,
                                cs,
                                'Certified',
                                AppAssets.certifiedIcon,
                                controller.selectedCategory.value ==
                                    'Certified',
                                () =>
                                    controller.onCategorySelected('Certified'),
                              ),
                              _buildCategoryItem(
                                tok,
                                tx,
                                cs,
                                'Top reviewe',
                                AppAssets.reviewIcon,
                                controller.selectedCategory.value ==
                                    'Top reviewed',
                                () => controller.onCategorySelected(
                                  'Top reviewed',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- Best Restaurants Title ---
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

                  // --- Restaurant List ---
                  Obx(() {
                    if (controller.isLoading.value ||
                        locationController.isLocationLoading.value &&
                            !locationController.hasLocation.value) {
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
                            onFavoriteToggle: () {
                              controller.toggleFavorite(restaurant.id);
                            },
                          );
                        }, childCount: controller.bestRestaurants.length),
                      ),
                    );
                  }),

                  // --- Footer ---
                  SliverToBoxAdapter(child: AppFooter()),
                ],
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final bottomNavController = Get.find<BottomNavController>();
        return AnimatedPadding(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
            bottom: bottomNavController.isNavBarVisible.value
                ? tok.gap.xxl * 2.4
                : tok.gap.md,
          ),
          child: AppShimmerFAB(
            onPressed: () => context.push(AppRoutes.mapScreen),
            child: SizedBox(
              height: height * 0.054,
              child: FloatingActionButton.extended(
                onPressed: null, // Animation wrapper handles taps
                backgroundColor: AppColor.primaryColor,
                elevation: 4,
                shape: StadiumBorder(side: BorderSide(color: cs.surface)),
                icon: SvgPicture.asset(
                  AppSvg.mapIcon,
                  width: tok.iconSm,
                  height: tok.iconSm,
                ),
                label: AppText(
                  "Map",
                  size: AppTextSize.s16,
                  weight: AppTextWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryItem(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    String label,
    String iconPath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Important for layout inside row/column
          children: [
            Container(
              padding: EdgeInsets.all(tok.gap.xs),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryColor.withOpacity(0.05)
                    : cs.surfaceContainerHighest.withOpacity(0.9),
                borderRadius: BorderRadius.circular(tok.radiusMd),
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryColor
                      : Colors.transparent,
                  width: 1.5,
                ),
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
              size:
                  AppTextSize.s10, // Slightly smaller text to prevent clipping
              weight: AppTextWeight.medium,
              color: isSelected ? AppColor.primaryColor : tx.subtle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow:
                  TextOverflow.visible, // Ensures it matches parent bounds
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({required this.tok, required this.cs, required this.tx});

  final AppTokens tok;
  final ColorScheme cs;
  final AppTextColors tx;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.100,
      padding: EdgeInsets.symmetric(
        horizontal: tok.gap.lg,
        // vertical: tok.gap.xxs,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: AppAnimatedSearchField(
              hints: const [
                "Search for \"Pizza\"",
                "Search for \"Biryani\"",
                "Search for \"Burger\"",
                "Search for \"Coffee\"",
              ],
              onChanged: (value) {},
            ),
          ),
          SizedBox(width: tok.gap.md),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FilterBottomSheet.show(context),
            child: Container(
              padding: EdgeInsets.all(tok.gap.xs),
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.setting_4_outline,
                color: tx.neutral,
                size: tok.iconLg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
