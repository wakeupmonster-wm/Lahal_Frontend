import 'package:flutter/material.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

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
                  Image.network(
                    restaurant.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: tok.gap.xs,
                    right: tok.gap.xs,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: tx.subtle,
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
                            AppColor.primaryColor.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: AppText(
                        restaurant.category,
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
              padding: EdgeInsets.all(tok.gap.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          restaurant.name,
                          size: AppTextSize.s16,
                          weight: AppTextWeight.bold,
                          color: tx.neutral,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                              restaurant.rating.toString(),
                              size: AppTextSize.s12,
                              weight: AppTextWeight.bold,
                              color: tx.inverse,
                            ),
                            SizedBox(width: tok.gap.xxs / 2),
                            Icon(Icons.star, color: tx.inverse, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppText(
                    restaurant.address,
                    size: AppTextSize.s12,
                    color: tx.subtle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: tok.gap.xxs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        '${restaurant.distance} away • \$\$',
                        size: AppTextSize.s12,
                        color: tx.subtle,
                      ),
                      AppText(
                        'by ${restaurant.reviewCount}',
                        size: AppTextSize.s10,
                        color: tx.muted,
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
