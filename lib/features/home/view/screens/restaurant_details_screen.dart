import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/features/home/controller/restaurant_details_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_details_model.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/components/shimmer/restaurant_details_shimmer.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailsScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final RestaurantDetailsController controller = Get.put(
    RestaurantDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    // Fetch details when screen loads
    controller.fetchRestaurantDetails(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const RestaurantDetailsShimmer();
        }

        final restaurant = controller.restaurant.value;
        if (restaurant == null) {
          return const EmptyStateWidget(
            title: "No Restaurants details found",
            description: "We couldn't find any restaurants details.",
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.45,
              backgroundColor: cs.surface,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(left: tok.gap.sm),
                    padding: EdgeInsets.all(tok.gap.xs),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: tx.inverse,
                      size: 15,
                    ),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(tok.gap.xs),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.heart_outline,
                      color: tx.inverse,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(width: tok.gap.xxs),
                // Center(
                //   child: Container(
                //     margin: EdgeInsets.only(right: tok.gap.lg),
                //     padding: EdgeInsets.all(tok.gap.xs),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.3),
                //       shape: BoxShape.circle,
                //     ),
                //     child: SvgPicture.asset(
                //       AppSvg.shareIcon,
                //       width: 15,
                //       height: 15,
                //     ),
                //   ),
                // ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  var isCollapsed =
                      top <=
                      kToolbarHeight + MediaQuery.of(context).padding.top + 20;

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    // titlePadding: EdgeInsets.only(
                    //   left: 60,
                    //   bottom: 16,
                    //   right: 100,
                    // ),
                    title: Container(
                      width: 190,
                      // color: Colors.red,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        opacity: isCollapsed ? 1.0 : 0.0,
                        child: AppText(
                          restaurant.restaurantName,
                          size: AppTextSize.s16,
                          weight: AppTextWeight.bold,
                          color: cs.onSurface,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    background: _buildFlexibleBackground(
                      context,
                      tok,
                      tx,
                      cs,
                      restaurant,
                      controller,
                      width,
                      height,
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(tok.gap.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Halal Summary Section ---
                    _buildSectionHeader(tx, 'Halal summary'),
                    SizedBox(height: tok.gap.md),
                    AppText(
                      restaurant.about.isNotEmpty
                          ? restaurant.about
                          : restaurant.halalInfo.summary,
                      size: AppTextSize.s14,
                      color: tx.subtle,
                    ),
                    SizedBox(height: tok.gap.md),
                    Wrap(
                      spacing: tok.gap.sm,
                      children: restaurant.halalSummaryTags.map((tag) {
                        return _buildTag(cs, tx, tag);
                      }).toList(),
                    ),

                    SizedBox(height: tok.gap.xl),

                    // --- Photos Grid ---
                    _buildSectionHeader(tx, 'Photos'),
                    SizedBox(height: tok.gap.md),
                    _buildPhotosGrid(tok, restaurant.photos, width, height),

                    SizedBox(height: tok.gap.xl),

                    // --- About this place ---
                    _buildSectionHeader(tx, 'About this place'),
                    SizedBox(height: tok.gap.md),
                    AppText(
                      restaurant.about.isNotEmpty
                          ? restaurant.about
                          : restaurant.halalInfo.summary,
                      size: AppTextSize.s14,
                      color: tx.subtle,
                    ),
                    SizedBox(height: tok.gap.md),
                    _buildAmenitiesCard(tok, tx, cs, restaurant),

                    SizedBox(height: tok.gap.xl),

                    // --- Reviews Section ---
                    if (restaurant.reviews.isNotEmpty) ...[
                      _buildSectionHeader(tx, 'Reviews'),
                      SizedBox(height: tok.gap.md),
                      _buildReviewsList(
                        tok,
                        tx,
                        cs,
                        restaurant.reviews,
                        controller,
                        width,
                        height,
                      ),
                      SizedBox(height: tok.gap.xl),
                    ],

                    // --- Connects Section ---
                    _buildSectionHeader(tx, 'Connects'),
                    SizedBox(height: tok.gap.md),
                    _buildConnectsGrid(tok, tx, cs, restaurant.contact),

                    SizedBox(height: tok.gap.xl),

                    // --- Footer ---
                    _buildFooter(tok, tx, cs, context, widget.restaurantId),
                    SizedBox(height: tok.gap.xl),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFlexibleBackground(
    BuildContext context,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    RestaurantDetailsModel restaurant,
    RestaurantDetailsController controller,
    double width,
    double height,
  ) {
    return Stack(
      children: [
        // Rounded Image Container (stops 28px from bottom to leave space for floating buttons)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: height * 0.03,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(tok.radiusLg + 4),
              bottomRight: Radius.circular(tok.radiusLg + 4),
            ),
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: restaurant.coverImage,
                    fit: BoxFit.cover,
                  ),
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
                // Restaurant Info
                Positioned(
                  bottom: tok.gap.xl + 4, // Space for floating buttons
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
                              restaurant.restaurantName,
                              size: AppTextSize.s24,
                              weight: AppTextWeight.bold,
                              color: tx.inverse,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: tok.gap.xxs / 2),
                            AppText(
                              restaurant.address.fullAddress,
                              size: AppTextSize.s14,
                              color: tx.inverse.withOpacity(0.9),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: tok.gap.xxs / 2),
                            AppText(
                              restaurant.formattedDistance,
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
                                  color: const Color(0xFF10B981),
                                  size: 16,
                                ),
                                SizedBox(width: tok.gap.xxs / 2),
                                Expanded(
                                  child: AppText(
                                    '${restaurant.statusText} | ${restaurant.openingHours}',
                                    size: AppTextSize.s12,
                                    color: tx.inverse,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: tok.gap.xxl * 2,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: tok.gap.xxxs,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF047857),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    restaurant.metrics.avgRating
                                        .toStringAsFixed(1),
                                    size: AppTextSize.s14,
                                    weight: AppTextWeight.bold,
                                    color: tx.inverse,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Icon(Icons.star, color: tx.inverse, size: 14),
                                ],
                              ),
                            ),
                            Container(
                              width: tok.gap.xxl * 2,
                              padding: EdgeInsets.symmetric(
                                vertical: tok.gap.xxxs,
                              ),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                children: [
                                  AppText(
                                    restaurant.metrics.totalReviews.toString(),
                                    size: AppTextSize.s14,
                                    weight: AppTextWeight.bold,
                                    color: tx.neutral,
                                  ),
                                  AppText(
                                    'Reviews',
                                    size: AppTextSize.s10,
                                    color: tx.neutral,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
          bottom: 0, // Touches the bottom of the layout, overlapping the image
          left: tok.gap.lg,
          right: tok.gap.lg,
          child: Row(
            children: [
              Expanded(
                child: _buildFloatingActionButton(
                  context: context,
                  label: "Directions",
                  iconPath: AppSvg.routingIcon,
                  onTap: () {
                    print("on tap of Direction");
                    controller.getDirections(context);
                  },
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(tok.radiusLg * 2),
          border: Border.all(color: cs.outline),
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

  Widget _buildPhotosGrid(
    AppTokens tok,
    List<String> photos,
    double width,
    double height,
  ) {
    if (photos.isEmpty) return const SizedBox.shrink();

    // Helper to build a single photo item
    Widget buildPhotoItem(String url) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(tok.radiusMd),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorWidget: (context, error, stackTrace) =>
              Container(color: Colors.grey.shade200),
        ),
      );
    }

    return Column(
      children: [
        // Top Row (Indices 0, 1, 2)
        if (photos.isNotEmpty)
          SizedBox(
            height: height * 0.268,
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
            height: height * 0.128,
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
    RestaurantDetailsModel restaurant,
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
          _buildAmenityRow(AppSvg.dishIcon, restaurant.cuisine, tx),
          _buildAmenityRow(
            AppSvg.locationNobcakgroundIcon, // Preserving user's variable
            restaurant.address.fullAddress,
            tx,
          ),
          SizedBox(height: tok.gap.xxxs),
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
          SizedBox(height: tok.gap.xxs),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6,
              mainAxisSpacing: tok.gap.xxs,
              crossAxisSpacing: tok.gap.xxs,
            ),
            itemCount: restaurant.availableAmenities.length,
            itemBuilder: (context, index) {
              final key = restaurant.availableAmenities[index];
              return Row(
                children: [
                  SvgPicture.asset(AppSvg.tickCircleIcon),
                  SizedBox(width: tok.gap.xxs),
                  Expanded(
                    child: AppText(
                      key,
                      size: AppTextSize.s12,
                      color: tx.subtle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
    List<RestaurantDetailsReview> reviews,
    RestaurantDetailsController controller,
    double width,
    double height,
  ) {
    return Obx(() {
      final isAnyExpanded = controller.expandedReviewIndices.isNotEmpty;
      return SizedBox(
        height: isAnyExpanded
            ? height * 0.215
            : height * 0.15, // Dynamic height
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: reviews.length,
          separatorBuilder: (_, __) => SizedBox(width: tok.gap.xs),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return _ReviewCard(
              review: review,
              tok: tok,
              tx: tx,
              cs: cs,
              controller: controller,
              index: index,
            );
          },
        ),
      );
    });
  }

  Widget _buildConnectsGrid(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    RestaurantDetailsContact contact,
  ) {
    final List<Map<String, dynamic>> items = [
      {'icon': Iconsax.global_outline, 'label': 'Website'},
      {'icon': Iconsax.facebook_outline, 'label': 'Facebook'},
      {'icon': Iconsax.sms_outline, 'label': 'Email'},
      {'icon': AppSvg.twitterIcon, 'label': 'Twitter'},
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(tok.gap.xxs),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.8),
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
                    size: AppTextSize.s10,
                    color: tx.subtle,
                    // align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (i < items.length - 1) SizedBox(width: tok.gap.xs),
        ],
      ],
    );
  }

  Widget _buildFooter(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    BuildContext context,
    String restaurantId,
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
                  onTap: () => context.push(AppRoutes.reportErrorScreen, extra: restaurantId),
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
          SvgPicture.asset(AppSvg.warning2Icon, width: 24, height: 20),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final RestaurantDetailsReview review;
  final AppTokens tok;
  final AppTextColors tx;
  final ColorScheme cs;
  final RestaurantDetailsController controller;
  final int index;

  const _ReviewCard({
    required this.review,
    required this.tok,
    required this.tx,
    required this.cs,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(review.user.imageUrl),
              ),
              SizedBox(width: tok.gap.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      review.user.userName,
                      size: AppTextSize.s14,
                      weight: AppTextWeight.bold,
                    ),
                    AppText(
                      review.createdAt,
                      size: AppTextSize.s10,
                      color: tx.muted,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

          Expanded(
            child: Obx(() {
              final isExpanded = controller.expandedReviewIndices.contains(
                index,
              );
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      review.comment,
                      size: AppTextSize.s12,
                      color: tx.subtle,
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                    if (review.comment.length > 60)
                      GestureDetector(
                        onTap: () => controller.toggleReviewExpansion(index),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: AppText(
                            isExpanded ? "less" : "more",
                            size: AppTextSize.s12,
                            weight: AppTextWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
