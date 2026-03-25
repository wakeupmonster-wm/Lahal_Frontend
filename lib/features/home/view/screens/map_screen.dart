import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/map_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/app_map_styles.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/features/profile/view/widgets/change_location_bottom_sheet.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map Layer
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              initialCameraPosition: MapController.initialCameraPosition,
              style: Theme.of(context).brightness == Brightness.dark
                  ? AppMapStyles.darkMapStyle
                  : null,
              markers: controller.markers,
              onMapCreated: (GoogleMapController mapController) {
                controller.mapController.complete(mapController);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // We'll build custom or hide it
              zoomControlsEnabled: false,
            );
          }),

          // 2. Top Section (Back Button, Location, Filters)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: tok.gap.md,
                        vertical: tok.gap.sm,
                      ),
                      child: Row(
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: EdgeInsets.all(tok.gap.xxs),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: tok.gap.xs),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ChangeLocationBottomSheet.show(context);
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: tok.gap.xxs),
                                  Flexible(
                                    child: AppText(
                                      "Sector A, Sarvanand Nagar...",
                                      size: AppTextSize.s16,
                                      color: Colors.white,
                                      weight: AppTextWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: tok.gap.xxs),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal Filter List
                    SizedBox(
                      height: height * 0.043,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: tok.gap.md),
                        children: [
                          _buildFilterChip(
                            "Near you",
                            Icons.location_on_outlined,
                            controller,
                            tok,
                            cs,
                            tx,
                          ),
                          _buildFilterChip(
                            "Top rated",
                            Icons.star,
                            controller,
                            tok,
                            cs,
                            tx,
                          ),
                          _buildFilterChip(
                            "Open now",
                            Icons.access_time,
                            controller,
                            tok,
                            cs,
                            tx,
                          ),
                          _buildFilterChip(
                            "Certified",
                            Icons.verified_outlined,
                            controller,
                            tok,
                            cs,
                            tx,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Carousel
          Positioned(
            bottom: tok.gap.xxl * 1,
            left: 0,
            right: 0,
            child: SizedBox(
              height: height * 0.20, // Adjust height as per design card
              child: Obx(() {
                if (controller.isLoading.value ||
                    controller.restaurants.isEmpty) {
                  return const SizedBox.shrink();
                }
                return PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.restaurants.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final restaurant = controller.restaurants[index];
                    return _buildMapRestaurantCard(
                      context,
                      restaurant,
                      tok,
                      cs,
                      tx,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData? icon,
    MapController controller,
    AppTokens tok,
    ColorScheme cs,
    AppTextColors tx,
  ) {
    return Obx(() {
      final isSelected = controller.selectedFilters.contains(label);
      return GestureDetector(
        onTap: () => controller.updateFilter(label),
        child: Container(
          margin: EdgeInsets.only(right: tok.gap.sm),
          padding: EdgeInsets.symmetric(
            horizontal: tok.gap.sm,
            // vertical: tok.gap.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : cs.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? cs.primary : cs.outlineVariant,
              width: 1.6,
            ),
            boxShadow: isSelected
                ? null
                : [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: tok.gap.xxs),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isSelected ? cs.onPrimary : tx.subtle,
                  ),
                ),
              AppText(
                label,
                size: AppTextSize.s14,
                color: isSelected ? cs.onPrimary : tx.subtle,
                weight: isSelected ? AppTextWeight.bold : AppTextWeight.regular,
              ),
              if (isSelected)
                Padding(
                  padding: EdgeInsets.only(left: tok.gap.xs),
                  child: Icon(Icons.close, size: 14, color: cs.onPrimary),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMapRestaurantCard(
    BuildContext context,
    RestaurantModel restaurant,
    AppTokens tok,
    ColorScheme cs,
    AppTextColors tx,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: tok.gap.xxxs,
        // vertical: tok.gap.xxxs,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(tok.radiusLg),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tok.gap.sm,
          vertical:
              tok.gap.md, // Slightly more vertical space for better balance
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Pins content to top and buttons to bottom
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image - Carefully sized
                ClipRRect(
                  borderRadius: BorderRadius.circular(tok.radiusSm),
                  child: Image.network(
                    restaurant.imageUrl,
                    width: width * 0.18,
                    height: height * 0.075,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: width * 0.18,
                      height: height * 0.075,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: tok.gap.sm),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppText(
                              restaurant.name,
                              size: AppTextSize.s14,
                              weight: AppTextWeight.bold,
                              color: tx.primary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: tok.gap.xxs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tok.gap.xxs,
                              vertical: tok.gap.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(tok.radiusSm),
                            ),
                            child: Row(
                              children: [
                                AppText(
                                  "${restaurant.rating}",
                                  size: AppTextSize.s10,
                                  weight: AppTextWeight.bold,
                                  color: cs.onPrimary,
                                ),
                                SizedBox(width: tok.gap.xxs),
                                Icon(Icons.star, color: cs.onPrimary, size: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppText(
                        restaurant.category,
                        size: AppTextSize.s10,
                        weight: AppTextWeight.medium,
                        color: tx.subtle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppText(
                        restaurant.distance,
                        size: AppTextSize.s10,
                        weight: AppTextWeight.medium,
                        color: tx.subtle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height:
                        height *
                        0.043, // Dynamic height (approx 36px on standard screen)
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(AppRoutes.restaurantDetails);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: AppText(
                        "View Restaurant",
                        size: AppTextSize.s12,
                        weight: AppTextWeight.bold,
                        color: cs.onPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02), // Dynamic gap
                _buildCompactButton(cs, AppSvg.routingIcon, width, height),
                SizedBox(width: width * 0.01), // Dynamic gap
                _buildCompactButton(cs, AppSvg.callCallingIcon, width, height),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactButton(
    ColorScheme cs,
    String iconPath,
    double width,
    double height,
  ) {
    return Container(
      width: width * 0.11, // Dynamic width (approx 40px)
      height: height * 0.043, // Dynamic height (approx 36px)
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        iconPath,
        width: width * 0.045, // Proportional icon size
        height: width * 0.045,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(Color(0xFF047857), BlendMode.srcIn),
      ),
    );
  }
}
