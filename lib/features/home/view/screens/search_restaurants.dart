import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/search_restaurants_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/shimmer/restaurant_card_shimmer.dart';
import 'package:lahal_application/utils/components/textfields/app_animated_search_field.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/components/widgets/restaurant_card.dart';
import 'package:lahal_application/utils/components/widgets/warning_dispaly.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';

class SearchRestaurantsScreen extends StatefulWidget {
  const SearchRestaurantsScreen({super.key});

  @override
  State<SearchRestaurantsScreen> createState() => _SearchRestaurantsScreenState();
}

class _SearchRestaurantsScreenState extends State<SearchRestaurantsScreen> {
  late final SearchRestaurantsController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchRestaurantsController());
    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreRestaurants();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<SearchRestaurantsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const InternalAppBar(
        title: "Search Restaurants",
      ),
      body: Column(
        children: [
          // Search Bar Area
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tok.gap.lg, vertical: tok.gap.md),
            child: AppAnimatedSearchField(
              hints: const [
                "Search for \"Pizza\"",
                "Search for \"Biryani\"",
                "Search for \"Burger\"",
                "Search for \"Coffee\"",
              ],
              autofocus: true,
              controller: controller.searchController,
              onChanged: (value) {
                controller.onSearchChanged(value);
              },
            ),
          ),
          
          Expanded(
            child: Obx(() {
                if (!controller.hasSearched.value && controller.searchQuery.value.isEmpty) {
                  return const Center(
                    child: EmptyStateWidget(
                      title: "Start searching",
                      description: "Find your favorite food, cuisines, and restaurants.",
                    ),
                  );
                }

                if (controller.isSearching.value) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: tok.gap.lg, vertical: tok.gap.xs),
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: tok.gap.md),
                      child: const RestaurantCardShimmer(),
                    ),
                  );
                }

                if (controller.errorMessage.isNotEmpty && controller.searchResults.isEmpty) {
                  return WarningDisplay(
                    warningMessage: "Something went wrong",
                    subWarningMessage: controller.errorMessage.value,
                    onRetry: () => controller.performSearch(reset: true),
                  );
                }

                if (controller.searchResults.isEmpty) {
                  return const EmptyStateWidget(
                    title: "No Restaurants Found",
                    description: "We couldn't find any restaurants matching your search.",
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: tok.gap.lg, vertical: tok.gap.xs),
                  itemCount: controller.searchResults.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.searchResults.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    final restaurant = controller.searchResults[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: tok.gap.md),
                      child: RestaurantCard(
                        restaurant: restaurant,
                        onTap: () {
                          context.push(
                            AppRoutes.restaurantDetails,
                            extra: {
                              'id': restaurant.id,
                              'isFav': restaurant.isFavourite,
                            },
                          );
                        },
                        onFavoriteToggle: () {
                          controller.toggleFavorite(restaurant.id);
                        },
                      ),
                    );
                  },
                );
            }),
          ),
        ],
      ),
    );
  }
}
