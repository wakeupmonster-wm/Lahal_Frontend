import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/map_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/app_map_styles.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

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
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: tok.gap.xs,
                    vertical: tok.gap.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(tok.gap.xxs),

                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: cs.onSurface,
                            size: tok.iconLg,
                          ),
                        ),
                      ),

                      // Location Header
                      Expanded(
                        child: Container(
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: tok.gap.md,
                          //   vertical: tok.gap.sm,
                          // ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: tx.primary,
                                size: 25,
                              ),
                              SizedBox(width: tok.gap.xxs),
                              Flexible(
                                child: AppText(
                                  "Melbourne, Victoria (VIC)",
                                  size: AppTextSize.s24,
                                  color: tx.primary,
                                  weight: AppTextWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: tok.gap.xxxs),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: tx.primary,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 34), // Balance back button width
                    ],
                  ),
                ),

                // Horizontal Filter List
                SizedBox(
                  height: 40,
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

          // 3. Bottom Carousel
          Positioned(
            bottom: tok.gap.xxl,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180, // Adjust height as per design card
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
      final isSelected = controller.selectedFilter.value == label;
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
          vertical: tok.gap.md,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(tok.radiusSm),
                  child: Image.network(
                    restaurant.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[800],
                      child: Icon(Icons.restaurant, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: tok.gap.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              restaurant.name,
                              size: AppTextSize.s16,
                              weight: AppTextWeight.bold,
                              color: tx.primary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tok.gap.xxs,
                              vertical: tok.gap.xxxs,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary, // Primary Green
                              borderRadius: BorderRadius.circular(tok.radiusSm),
                            ),
                            child: Row(
                              children: [
                                AppText(
                                  "${restaurant.rating}",
                                  size: AppTextSize.s12,
                                  weight: AppTextWeight.bold,
                                  color: cs.onPrimary,
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.star, color: cs.onPrimary, size: 13),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: tok.gap.xxxs),
                      AppText(
                        restaurant.category,
                        size: AppTextSize.s12,
                        weight: AppTextWeight.bold,
                        color: tx.subtle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: tok.gap.xxxs),
                      AppText(
                        restaurant.distance,
                        size: AppTextSize.s12,
                        weight: AppTextWeight.bold,
                        color: tx.subtle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Buttons
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: tok.gap.xxxs),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(AppRoutes.restaurantDetails);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0),
                      // minimumSize: Size(0, 36),
                    ),
                    child: AppText(
                      "View Restaurant",
                      size: AppTextSize.s12,
                      weight: AppTextWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
                SizedBox(width: tok.gap.sm),
                _buildCircleButton(Icons.percent_outlined, cs, tx),
                SizedBox(width: tok.gap.sm),
                _buildCircleButton(Icons.call_outlined, cs, tx),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, ColorScheme cs, AppTextColors tx) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant),
        color: Colors.transparent,
      ),
      child: Icon(icon, color: tx.primary, size: 18),
    );
  }
}
