import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: tok.gap.lg),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(tok.radiusLg),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(tok.radiusLg),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: restaurant.restaurantImg,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) => Container(
                      height: 200,
                      color: cs.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 48,
                          color: tx.subtle,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: tok.gap.xs,
                    right: tok.gap.xs,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          restaurant.isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 22,
                          color: restaurant.isFavourite
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tok.gap.xs,
                        vertical: tok.gap.xxs,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            cs.primary.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: AppText(
                        restaurant.cuisine,
                        size: AppTextSize.s12,
                        weight: AppTextWeight.medium,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(tok.gap.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              restaurant.restaurantName,
                              size: AppTextSize.s16,
                              weight: AppTextWeight.bold,
                              color: tx.neutral,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: tok.gap.xxs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AppText(
                                    restaurant.address.fullAddress,
                                    size: AppTextSize.s12,
                                    color: tx.subtle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: tok.gap.xxs),
                            AppText(
                              restaurant.formattedDistance.isNotEmpty
                                  ? '${restaurant.formattedDistance} away • \$\$'
                                  : '\$\$',
                              size: AppTextSize.s12,
                              color: tx.subtle,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tok.gap.xxs,
                              vertical: tok.gap.xxs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(tok.radiusSm),
                            ),
                            child: Row(
                              children: [
                                AppText(
                                  restaurant.metrics.avgRating.toString(),
                                  size: AppTextSize.s12,
                                  weight: AppTextWeight.bold,
                                  color: tx.inverse,
                                ),
                                SizedBox(width: tok.gap.xxs / 2),
                                Icon(Icons.star, color: tx.inverse, size: 14),
                              ],
                            ),
                          ),
                          SizedBox(height: tok.gap.xxs),
                          AppText(
                            'by ${restaurant.metrics.totalReviews}',
                            size: AppTextSize.s12,
                            color: tx.subtle,
                          ),
                        ],
                      ),
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
}
