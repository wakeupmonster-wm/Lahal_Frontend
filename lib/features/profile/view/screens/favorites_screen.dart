import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lahal_application/features/profile/controller/favorite_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/widgets/restaurant_card.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/components/widgets/warning_dispaly.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/components/shimmer/restaurant_card_shimmer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(title: AppStrings.favorites, centerTitle: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer(tok);
        }

        if (controller.hasError.value) {
          return Center(
            child:
                WarningDisplay(
                      warningMessage: "Something went wrong",
                      subWarningMessage:
                          "Failed to load favorites. Please try again.",
                      onRetry: controller.fetchFavorites,
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                    ),
          );
        }

        if (controller.favoriteRestaurants.isEmpty) {
          return Center(
            child:
                EmptyStateWidget(
                      title: AppStrings.noFavoritesYet,
                      description: AppStrings.favoritesDescription,
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                    ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: cs.primary,
          child: ListView.builder(
            padding: EdgeInsets.all(tok.gap.lg),
            itemCount: controller.favoriteRestaurants.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                      padding: EdgeInsets.only(bottom: tok.gap.md),
                      child: AppText(
                        AppStrings.yourLikedRestaurants,
                        size: AppTextSize.s18,
                        weight: AppTextWeight.bold,
                        color: tx.primary,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: -0.1, end: 0);
              }
              final favorite = controller.favoriteRestaurants[index - 1];
              return RestaurantCard(restaurant: favorite.toRestaurantModel())
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (index * 80).ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutQuad,
                  );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmer(AppTokens tok) {
    return ListView.builder(
      padding: EdgeInsets.all(tok.gap.lg),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const RestaurantCardShimmer().animate().fadeIn(
          duration: 400.ms,
          delay: (index * 100).ms,
        );
      },
    );
  }
}
