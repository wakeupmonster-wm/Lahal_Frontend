import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Green Curved Header ---
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cs.primary, // The brand green color
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
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
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: tok.gap.xs),
                                const AppText(
                                  'LaLah',
                                  size: AppTextSize.s24,
                                  weight: AppTextWeight.bold,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SvgPicture.asset(AppSvg.notificaitonIcon),
                          ],
                        ),
                        SizedBox(height: tok.gap.md),

                        // Location Row
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: tok.gap.xs),
                            const AppText(
                              'Melbourne, Victoria (VIC)',
                              size: AppTextSize.s14,
                              weight: AppTextWeight.medium,
                              color: Colors.white,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                        SizedBox(height: tok.gap.md),

                        // Search Bar & Filter
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: tx.subtle,
                                      size: 24,
                                    ),
                                    SizedBox(width: tok.gap.sm),
                                    Expanded(
                                      child: TextField(
                                        style: TextStyle(color: tx.neutral),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search for area, street name...',
                                          hintStyle: TextStyle(
                                            color: tx.subtle,
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: tok.gap.md),
                            SvgPicture.asset(AppSvg.filterIcon),
                          ],
                        ),
                        SizedBox(height: tok.gap.lg),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- Category Section ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.md),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryItem(tok, tx, cs, 'Near you', AppSvg.mapIcon),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Top rated',
                      AppSvg.thumbIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Open now',
                      AppSvg.clockIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Certified',
                      AppSvg.certifiedIcon,
                    ),
                    _buildCategoryItem(
                      tok,
                      tx,
                      cs,
                      'Top reviewed',
                      AppSvg.starIcon,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: tok.gap.md),

            // --- Best Restaurants Heading ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              child: AppText(
                'Best restaurants',
                size: AppTextSize.s18,
                weight: AppTextWeight.bold,
                color: tx.neutral,
              ),
            ),
            SizedBox(height: tok.gap.md),

            // --- Restaurant List ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              itemCount: 2,
              itemBuilder: (context, index) {
                return _buildRestaurantCard(tok, tx, cs);
              },
            ),
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
      padding: EdgeInsets.only(right: tok.gap.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: cs.onSurface.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SvgPicture.asset(
              iconPath,
              // width: 24,
              // height: 24,
              // colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
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

  Widget _buildRestaurantCard(AppTokens tok, AppTextColors tx, ColorScheme cs) {
    return Container(
      margin: EdgeInsets.only(bottom: tok.gap.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  right: 12,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color: Colors.black.withOpacity(0.3),
                    child: const AppText(
                      'Middle Eastern restaurant',
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Rose Garden Restaurant',
                      size: AppTextSize.s16,
                      weight: AppTextWeight.bold,
                      color: tx.neutral,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const AppText(
                            '5',
                            size: AppTextSize.s12,
                            weight: AppTextWeight.bold,
                            color: Colors.white,
                          ),
                          SizedBox(width: tok.gap.xxs),
                          const Icon(Icons.star, color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                AppText(
                  'Melbourne, VIC 3001',
                  size: AppTextSize.s12,
                  color: tx.subtle,
                ),
                SizedBox(height: tok.gap.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      '1.6 km away • \$\$',
                      size: AppTextSize.s12,
                      color: tx.subtle,
                    ),
                    AppText('by 120', size: AppTextSize.s10, color: tx.muted),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
