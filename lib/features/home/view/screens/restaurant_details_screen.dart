import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/features/home/controller/restaurant_details_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

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
          return const Center(child: AppText('No details found'));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Image & Overlay ---
                  _buildHeader(context, tok, tx, cs, restaurant),

                  Padding(
                    padding: EdgeInsets.all(tok.gap.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Quick Actions Row ---
                        _buildQuickActions(tok, tx, cs, controller),

                        SizedBox(height: tok.gap.lg),

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
                        _buildFooter(tok, tx, cs),
                        SizedBox(height: tok.gap.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Back Button Overlay (Fixed)
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(tok.gap.md),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
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
  ) {
    return Stack(
      children: [
        Image.network(
          restaurant.imageUrl,
          height: 350,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: Row(
            children: [
              _buildRoundIcon(Iconsax.share_outline),
              const SizedBox(width: 12),
              _buildRoundIcon(Iconsax.heart_outline),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
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
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      restaurant.address,
                      size: AppTextSize.s14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      restaurant.distance,
                      size: AppTextSize.s14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          '${restaurant.status} | ${restaurant.openingHours}',
                          size: AppTextSize.s12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF047857),
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
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
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
                          color: const Color(0xFF4B5563),
                        ),
                        const AppText(
                          'Reviews',
                          size: AppTextSize.s10,
                          color: Color(0xFF9CA3AF),
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
    );
  }

  Widget _buildRoundIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildQuickActions(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    RestaurantDetailsController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.getDirections,
            icon: const Icon(Iconsax.location_outline, size: 20),
            label: const AppText('Directions', size: AppTextSize.s14),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              side: BorderSide(color: cs.outlineVariant),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.callRestaurant,
            icon: const Icon(Iconsax.call_calling_outline, size: 20),
            label: const AppText('Call', size: AppTextSize.s14),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              side: BorderSide(color: cs.outlineVariant),
            ),
          ),
        ),
      ],
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(photos[0], height: 250, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(photos[1], height: 121, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(photos[2], height: 121, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildAmenityRow(Iconsax.shop_outline, restaurant.category, tx),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: tx.subtle.withOpacity(0.1)),
          ),
          _buildAmenityRow(Iconsax.location_outline, restaurant.address, tx),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              'Amenities',
              size: AppTextSize.s16,
              weight: AppTextWeight.bold,
              color: tx.neutral,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
            ),
            itemCount: restaurant.amenities.length,
            itemBuilder: (context, index) {
              final key = restaurant.amenities.keys.elementAt(index);
              return Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 8),
                  AppText(key, size: AppTextSize.s12, color: tx.subtle),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityRow(IconData icon, String text, AppTextColors tx) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF047857)),
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
    );
  }

  Widget _buildReviewsList(
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    List<ReviewModel> reviews,
  ) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            width: 300,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(width: 12),
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
                const SizedBox(height: 12),
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
      if (connects.twitter != null)
        {'icon': Iconsax.omega_circle_outline, 'label': 'Twitter'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(items[index]['icon'], color: tx.subtle, size: 28),
              const SizedBox(height: 8),
              AppText(
                items[index]['label'],
                size: AppTextSize.s12,
                color: tx.subtle,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter(AppTokens tok, AppTextColors tx, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 12),
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
                  onTap: () {},
                  child: const AppText(
                    'Report error \u2192',
                    size: AppTextSize.s12,
                    weight: AppTextWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.location_on_outlined,
            size: 40,
            color: tx.subtle.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
