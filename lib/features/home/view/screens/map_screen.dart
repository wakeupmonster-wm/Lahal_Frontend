import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/map_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    horizontal: tok.gap.md,
                    vertical: tok.gap.sm,
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(tok.gap.xs),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: tok.gap.sm),

                      // Location Header
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tok.gap.md,
                            vertical: tok.gap.xs,
                          ),
                          // decoration: BoxDecoration(
                          //   color: Colors.black.withOpacity(0.5),
                          //   borderRadius: BorderRadius.circular(20),
                          // ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: tok.gap.xs),
                              Flexible(
                                child: Text(
                                  "Melbourne, Victoria (VIC)", // TODO: Bind to controller location
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: tok.gap.xl), // Balance row
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
                        AppAssets.mapIcon,
                        controller,
                        tok,
                        cs,
                        tx,
                      ),
                      _buildFilterChip(
                        "Top rated",
                        AppAssets.thumbIcon,
                        controller,
                        tok,
                        cs,
                        tx,
                      ),
                      _buildFilterChip(
                        "Open now",
                        AppAssets.clockIcon,
                        controller,
                        tok,
                        cs,
                        tx,
                      ),
                      _buildFilterChip(
                        "Certified",
                        AppAssets.certifiedIcon,
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
            bottom: tok.gap.lg,
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
    String iconPath,
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
            horizontal: tok.gap.md,
            vertical: tok.gap.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryColor
                : Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // Icon (using SVG or Icon depending on asset type, assuming SVG per project)
              // If assets are strictly images/svgs, verifying usage.
              // Assuming SVG for now based on home_screen usage.
              if (iconPath.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(right: tok.gap.xs),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
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
      margin: EdgeInsets.symmetric(horizontal: tok.gap.xs),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark card background from screenshot
        borderRadius: BorderRadius.circular(tok.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(tok.gap.sm),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(tok.radiusMd),
              child: Image.network(
                restaurant.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${restaurant.rating}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.star, color: Colors.white, size: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    restaurant.category,
                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    restaurant.distance,
                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                  ),
                  SizedBox(height: tok.gap.md),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(AppRoutes.restaurantDetails);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 0),
                            minimumSize: Size(0, 32),
                          ),
                          child: Text(
                            "View Restaurant",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: tok.gap.xs),
                      _buildCircleButton(Icons.directions_outlined),
                      SizedBox(width: tok.gap.xs),
                      _buildCircleButton(Icons.call_outlined),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Icon(icon, color: Colors.grey[400], size: 16),
    );
  }
}
