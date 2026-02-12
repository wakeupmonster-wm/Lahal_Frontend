import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/features/home/controller/restaurant_details_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/features/home/view/screens/report_error_screen.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantDetailsController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurant = controller.restaurant.value;
        if (restaurant == null) {
          return const EmptyStateWidget(
            title: "No Restaurants details found",
            description: "We couldn't find any restaurants details.",
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Image & Overlay ---
                  _buildHeader(context, tok, tx, cs, restaurant, controller),
                  SizedBox(height: tok.gap.xl), // Spacing for floating buttons

                  Padding(
                    padding: EdgeInsets.all(tok.gap.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Halal Summary Section ---
                        _buildSectionHeader(tx, 'Halal summary'),
                        SizedBox(height: tok.gap.md),
                        AppText(
                          restaurant.description,
                          size: AppTextSize.s14,
                          color: tx.subtle,
                        ),
                        SizedBox(height: tok.gap.md),
                        Wrap(
                          spacing: tok.gap.sm,
                          children: restaurant.halalSummary.map((tag) {
                            return _buildTag(cs, tx, tag);
                          }).toList(),
                        ),

                        SizedBox(height: tok.gap.xl),

                        // --- Photos Grid ---
                        _buildSectionHeader(tx, 'Photos'),
                        SizedBox(height: tok.gap.md),
                        _buildPhotosGrid(tok, restaurant.photos),

                        SizedBox(height: tok.gap.xl),

                        // --- About this place ---
                        _buildSectionHeader(tx, 'About this place'),
                        SizedBox(height: tok.gap.md),
                        AppText(
                          restaurant.description,
                          size: AppTextSize.s14,
                          color: tx.subtle,
                        ),
                        SizedBox(height: tok.gap.md),
                        _buildAmenitiesCard(tok, tx, cs, restaurant),

                        SizedBox(height: tok.gap.xl),

                        // --- Reviews Section ---
                        _buildSectionHeader(tx, 'Reviews'),
                        SizedBox(height: tok.gap.md),
                        _buildReviewsList(tok, tx, cs, restaurant.reviews),

                        SizedBox(height: tok.gap.xl),

                        // --- Connects Section ---
                        _buildSectionHeader(tx, 'Connects'),
                        SizedBox(height: tok.gap.md),
                        _buildConnectsGrid(
                          tok,
                          tx,
                          cs,
                          restaurant.socialConnects,
                        ),

                        SizedBox(height: tok.gap.xl),

                        // --- Footer ---
                        _buildFooter(tok, tx, cs, context),
                        SizedBox(height: tok.gap.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    RestaurantModel restaurant,
    RestaurantDetailsController controller,
  ) {
    // Responsive height: 40% of screen height
    final headerHeight = MediaQuery.of(context).size.height * 0.4;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Rounded Image Container
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(tok.radiusLg + 4), // Approx 20
            bottomRight: Radius.circular(tok.radiusLg + 4),
          ),
          child: SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.network(restaurant.imageUrl, fit: BoxFit.cover),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // Back Button & Actions
                Positioned(
                  top: 60,
                  right: 20,
                  left: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(tok.gap.xxs),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: tx.inverse,
                            size: tok.iconSm,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildRoundIcon(Iconsax.share_outline, tx, tok),
                          SizedBox(width: tok.gap.xs),
                          _buildRoundIcon(Iconsax.heart_outline, tx, tok),
                        ],
                      ),
                    ],
                  ),
                ),
                // Restaurant Info
                Positioned(
                  bottom: tok.gap.xl + 12, // Space for floating buttons
                  left: tok.gap.lg,
                  right: tok.gap.lg,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              restaurant.name,
                              size: AppTextSize.s24,
                              weight: AppTextWeight.bold,
                              color: tx.inverse,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: tok.gap.xxs / 2),
                            AppText(
                              restaurant.address,
                              size: AppTextSize.s14,
                              color: tx.inverse.withOpacity(0.9),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: tok.gap.xxs / 2),
                            AppText(
                              restaurant.distance,
                              size: AppTextSize.s14,
                              color: tx.inverse.withOpacity(0.9),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: tok.gap.xxs),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: const Color(
                                    0xFF10B981,
                                  ), // Keep brand color or use success token if available
                                  size: 16,
                                ),
                                SizedBox(width: tok.gap.xxs / 2),
                                AppText(
                                  '${restaurant.status} | ${restaurant.openingHours}',
                                  size: AppTextSize.s12,
                                  color: tx.inverse,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tok.gap.sm,
                              vertical: tok.gap.xxs,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFF047857), // Keep brand color
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                AppText(
                                  restaurant.rating.toStringAsFixed(0),
                                  size: AppTextSize.s14,
                                  weight: AppTextWeight.bold,
                                  color: tx.inverse,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: tok.gap.xs),
                                Icon(Icons.star, color: tx.inverse, size: 14),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tok.gap.sm,
                              vertical: tok.gap.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              children: [
                                AppText(
                                  restaurant.reviewCount.toString(),
                                  size: AppTextSize.s14,
                                  weight: AppTextWeight.bold,
                                  color: tx.neutral,
                                ),
                                AppText(
                                  'Reviews',
                                  size: AppTextSize.s10,
                                  color: tx.subtle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating Action Buttons
        Positioned(
          bottom: -28,
          left: tok.gap.lg,
          right: tok.gap.lg,
          child: Row(
            children: [
              Expanded(
                child: _buildFloatingActionButton(
                  context: context,
                  label: "Directions",
                  iconPath: AppSvg.routingIcon,
                  onTap: controller.getDirections,
                  tok: tok,
                  tx: tx,
                  cs: cs,
                ),
              ),
              SizedBox(width: tok.gap.sm),
              Expanded(
                child: _buildFloatingActionButton(
                  context: context,
                  label: "Call",
                  iconPath: AppSvg.callCallingIcon,
                  onTap: controller.callRestaurant,
                  tok: tok,
                  tx: tx,
                  cs: cs,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton({
    required BuildContext context,
    required String label,
    required String iconPath,
    required VoidCallback onTap,
    required AppTokens tok,
    required AppTextColors tx,
    required ColorScheme cs,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(tok.radiusLg * 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(tok.radiusLg * 2),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: tok.gap.sm - 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: tok.iconSm,
                  height: tok.iconSm,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF047857), // Keep brand color
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: tok.gap.xs),
                AppText(
                  label,
                  size: AppTextSize.s16,
                  weight: AppTextWeight.medium,
                  color: tx.neutral, // Using neutral instead of hardcoded
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundIcon(IconData icon, AppTextColors tx, AppTokens tok) {
    return Container(
      padding: EdgeInsets.all(tok.gap.xxs),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: tx.inverse, size: tok.iconSm),
    );
  }

  Widget _buildSectionHeader(AppTextColors tx, String title) {
    return Row(
      children: [
        AppText(
          title,
          size: AppTextSize.s18,
          weight: AppTextWeight.bold,
          color: tx.neutral,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: tx.subtle.withOpacity(0.2), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildTag(ColorScheme cs, AppTextColors tx, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(label, size: AppTextSize.s12, color: tx.subtle),
    );
  }

  Widget _buildPhotosGrid(AppTokens tok, List<String> photos) {
    if (photos.isEmpty) return const SizedBox.shrink();

    // Helper to build a single photo item
    Widget buildPhotoItem(String url) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(tok.radiusMd),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey.shade200),
        ),
      );
    }

    return Column(
      children: [
        // Top Row (Indices 0, 1, 2)
        if (photos.isNotEmpty)
          SizedBox(
            height: 250,
            child: Row(
              children: [
                // Big Image (Index 0)
                Expanded(flex: 2, child: buildPhotoItem(photos[0])),
                if (photos.length > 1) ...[
                  SizedBox(width: tok.gap.sm),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(child: buildPhotoItem(photos[1])),
                        if (photos.length > 2) ...[
                          SizedBox(height: tok.gap.sm),
                          Expanded(child: buildPhotoItem(photos[2])),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

        // Bottom Row (Indices 3, 4, 5)
        if (photos.length > 3) ...[
          SizedBox(height: tok.gap.sm),
          SizedBox(
            height: 120,
            child: Row(
              children: [
                Expanded(child: buildPhotoItem(photos[3])),
                if (photos.length > 4) ...[
                  SizedBox(width: tok.gap.sm),
                  Expanded(child: buildPhotoItem(photos[4])),
                ],
                if (photos.length > 5) ...[
                  SizedBox(width: tok.gap.sm),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        buildPhotoItem(photos[5]),
                        if (photos.length > 6)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(tok.radiusMd),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              alignment: Alignment.center,
                              child: AppText(
                                '+${photos.length - 6}',
                                size: AppTextSize.s24,
                                weight: AppTextWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAmenitiesCard(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    RestaurantModel restaurant,
  ) {
    return Container(
      padding: EdgeInsets.all(tok.gap.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(tok.radiusLg),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildAmenityRow(AppSvg.dishIcon, restaurant.category, tx),
          _buildAmenityRow(
            AppSvg.locationNobcakgroundIcon, // Preserving user's variable
            restaurant.address,
            tx,
          ),
          SizedBox(height: tok.gap.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                AppText(
                  'Amenities',
                  size: AppTextSize.s16,
                  weight: AppTextWeight.bold,
                  color: tx.neutral,
                ),
                SizedBox(width: tok.gap.xxs),
                Expanded(child: Divider(color: tx.subtle.withOpacity(0.1))),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6,
              mainAxisSpacing: tok.gap.xs,
              crossAxisSpacing: tok.gap.xs,
            ),
            itemCount: restaurant.amenities.length,
            itemBuilder: (context, index) {
              final key = restaurant.amenities.keys.elementAt(index);
              return Row(
                children: [
                  SvgPicture.asset(AppSvg.tickCircleIcon),
                  SizedBox(width: tok.gap.xxs),
                  AppText(key, size: AppTextSize.s12, color: tx.subtle),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityRow(String svg, String text, AppTextColors tx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SvgPicture.asset(svg),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              text,
              size: AppTextSize.s14,
              color: tx.subtle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    List<ReviewModel> reviews,
  ) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        separatorBuilder: (_, __) => SizedBox(width: tok.gap.xs),
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            width: 300,
            padding: EdgeInsets.all(tok.gap.xs),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(tok.radiusMd),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(review.userImageUrl),
                    ),
                    SizedBox(width: tok.gap.xs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            review.userName,
                            size: AppTextSize.s14,
                            weight: AppTextWeight.bold,
                          ),
                          AppText(
                            review.date,
                            size: AppTextSize.s10,
                            color: tx.muted,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF047857),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          AppText(
                            review.rating.toStringAsFixed(0),
                            size: AppTextSize.s10,
                            weight: AppTextWeight.bold,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.star, color: Colors.white, size: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tok.gap.xs),
                AppText(
                  review.comment,
                  size: AppTextSize.s12,
                  color: tx.subtle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectsGrid(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    SocialConnects connects,
  ) {
    final List<Map<String, dynamic>> items = [
      if (connects.website != null)
        {'icon': Iconsax.global_outline, 'label': 'Website'},
      if (connects.facebook != null)
        {'icon': Iconsax.facebook_outline, 'label': 'Facebook'},
      if (connects.email != null)
        {'icon': Iconsax.sms_outline, 'label': 'Email'},
      if (connects.twitter.isNotEmpty)
        {'icon': AppSvg.twitterIcon, 'label': 'Twitter'},
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(
            child: Container(
              // aspectRatio: 1,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.2),
                borderRadius: BorderRadius.circular(tok.radiusMd),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (items[i]['icon'] is IconData)
                    Icon(items[i]['icon'], color: tx.subtle, size: tok.iconLg)
                  else if (items[i]['icon'] is String)
                    SvgPicture.asset(
                      items[i]['icon'],
                      width: tok.iconLg,
                      height: tok.iconLg,
                      colorFilter: ColorFilter.mode(tx.subtle, BlendMode.srcIn),
                    ),
                  SizedBox(height: tok.gap.xs),
                  AppText(
                    items[i]['label'],
                    size: AppTextSize.s12,
                    color: tx.subtle,
                    // align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (i < items.length - 1) SizedBox(width: tok.gap.sm),
        ],
      ],
    );
  }

  Widget _buildFooter(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(tok.gap.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(tok.radiusMd),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppSvg.warning1Icon),
          SizedBox(width: tok.gap.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Found something incorrect? Help us fix it.',
                  size: AppTextSize.s12,
                  color: tx.subtle,
                ),
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.reportErrorScreen);
                    // Get.to(() => const ReportErrorScreen());
                  },
                  child: AppText(
                    'Report error \u2192',
                    size: AppTextSize.s12,
                    weight: AppTextWeight.bold,
                    color: tx.error,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(AppSvg.locationIcon),
        ],
      ),
    );
  }
}
