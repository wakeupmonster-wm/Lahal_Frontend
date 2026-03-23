import 'dart:async';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';
import 'package:lahal_application/features/home/services/home_api_service.dart';
import 'package:lahal_application/features/home/services/home_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class HomeController extends GetxController {
  late final HomeService _homeService;

  // ---- Restaurant List State ----
  final RxList<RestaurantModel> bestRestaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = "".obs;

  // ---- Pagination State ----
  int _currentPage = 1;
  final int _pageLimit = 20;
  bool _hasMoreData = true;

  // ---- Filter State ----
  // null means no filter is active (no params sent)
  final Rx<RestaurantFilters?> selectedFilter = Rx<RestaurantFilters?>(null);
  final RxString selectedCategory = ''.obs;

  // ---- Search State ----
  final RxString searchQuery = ''.obs;
  Timer? _searchDebounce;

  // ---- Filter Bottom Sheet State ----
  // 0 = no distance filter; slider starts at 0
  final RxDouble distanceRange = 0.0.obs;
  final RxInt rating = 0.obs;
  final RxList<String> allCuisines = <String>[
    'Italian 🍝',
    'Indian 🍛',
    'Chinese 🥢',
    'Mexican 🌮',
    'Thai 🍜',
    'Vegetarian 🥗',
  ].obs;
  final RxList<String> selectedCuisines = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Register DI dependencies
    if (!Get.isRegistered<HomeRepository>()) Get.put(HomeRepository());
    if (!Get.isRegistered<HomeApiService>()) Get.put(HomeApiService());
    if (!Get.isRegistered<HomeService>()) Get.put(HomeService());

    _homeService = Get.find<HomeService>();
    fetchRestaurants();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  // ---- Category / Filter Selection ----

  void onCategorySelected(String category) {
    if (selectedCategory.value == category) {
      // Tapping the already-selected filter → deselect (no filter, no params)
      selectedCategory.value = '';
      selectedFilter.value = null;
    } else {
      selectedCategory.value = category;
      selectedFilter.value = _mapCategoryToFilter(category);
    }
    fetchRestaurants(reset: true);
  }

  RestaurantFilters _mapCategoryToFilter(String category) {
    switch (category) {
      case 'Near you':
        return RestaurantFilters.near_you;
      case 'Top rated':
        return RestaurantFilters.top_rated;
      case 'Open now':
        return RestaurantFilters.open_now;
      case 'Certified':
        return RestaurantFilters.certified;
      case 'Top reviewed':
        return RestaurantFilters.top_reviewed;
      default:
        return RestaurantFilters.near_you;
    }
  }

  // ---- Search ----

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery.value = query;
      fetchRestaurants(reset: true);
    });
  }

  // ---- Fetch Restaurants ----

  Future<void> fetchRestaurants({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _hasMoreData = true;
      bestRestaurants.clear();
    }

    if (!_hasMoreData) return;

    // Conditionally pass lat/lng and filter based on active selection
    final filter = selectedFilter.value;
    double? lat;
    double? lng;

    // Only send lat/lng when "Near you" is the active filter
    if (filter == RestaurantFilters.near_you) {
      try {
        final locationController = Get.find<LocationController>();
        if (locationController.hasLocation.value) {
          lat = locationController.latitude.value;
          lng = locationController.longitude.value;
        }
      } catch (_) {
        // LocationController might not be registered yet
      }
    }

    // Only pass filter param for non-near_you active filters
    final apiFilter = (filter != null && filter != RestaurantFilters.near_you)
        ? filter
        : null;

    _homeService.loadRestaurants(
      page: _currentPage,
      limit: _pageLimit,
      filter: apiFilter,
      search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      lat: lat,
      lng: lng,
      // Bottom sheet filter params
      distance: distanceRange.value > 0 ? distanceRange.value : null,
      minRating: rating.value > 0 ? rating.value : null,
      cuisine: selectedCuisines.isNotEmpty
          ? selectedCuisines.join(',')  // e.g. "Italian,Indian"
          : null,
      isLoading: _currentPage == 1 ? isLoading : isLoadingMore,
      errorMessage: errorMessage,
      onSuccess: (restaurants, metadata) {
        if (_currentPage == 1) {
          bestRestaurants.assignAll(restaurants);
        } else {
          bestRestaurants.addAll(restaurants);
        }

        // Determine if there's more data
        _hasMoreData = metadata.hasMore;
        _currentPage++;
      },
      onError: (error) {
        AppLogger.e('HomeController', 'Failed to fetch restaurants', error);
      },
    );
  }

  /// Called by the scroll listener when user reaches bottom
  void loadMoreRestaurants() {
    if (!isLoadingMore.value && _hasMoreData && !isLoading.value) {
      fetchRestaurants();
    }
  }

  /// Pull-to-refresh
  Future<void> getBestRestaurants() async {
    await fetchRestaurants(reset: true);
  }

  // ---- Favorites ----

  void toggleFavorite(String restaurantId) {
    final index = bestRestaurants.indexWhere((r) => r.id == restaurantId);
    if (index == -1) return;

    final restaurant = bestRestaurants[index];
    final isCurrentlyFavorite = restaurant.isFavourite;

    // Optimistically update UI
    bestRestaurants[index] = restaurant.copyWith(
      isFavourite: !isCurrentlyFavorite,
    );
    bestRestaurants.refresh();

    // Call the appropriate API
    if (isCurrentlyFavorite) {
      // It was favorite, user clicked to remove
      _homeService.removeFavorite(
        restaurantId: restaurantId,
        isLoading: false.obs, // Background task, no blocking loader needed
        errorMessage: ''.obs,
        onSuccess: (message) {
          AppSnackBar.showToast(message: message);
        },
        onError: (error) {
          // Revert optimistic update
          bestRestaurants[index] = restaurant.copyWith(
            isFavourite: isCurrentlyFavorite,
          );
          bestRestaurants.refresh();
          AppSnackBar.showToast(message: 'Failed to remove from favorites');
        },
      );
    } else {
      // It was not favorite, user clicked to add
      _homeService.addFavorite(
        restaurantId: restaurantId,
        isLoading: false.obs,
        errorMessage: ''.obs,
        onSuccess: (message) {
          AppSnackBar.showToast(message: message);
        },
        onError: (error) {
          // Revert optimistic update
          bestRestaurants[index] = restaurant.copyWith(
            isFavourite: isCurrentlyFavorite,
          );
          bestRestaurants.refresh();
          AppSnackBar.showToast(message: 'Failed to add to favorites');
        },
      );
    }
  }

  // ---- Filter Bottom Sheet ----

  void updateDistanceRange(double value) {
    distanceRange.value = value;
  }

  void updateRating(int value) {
    rating.value = value;
  }

  void clearFilters() {
    distanceRange.value = 0.0;  // 0 = no distance filter
    rating.value = 0;
    selectedCuisines.clear();
    fetchRestaurants(reset: true);
  }

  void toggleCuisine(String cuisine) {
    if (selectedCuisines.contains(cuisine)) {
      selectedCuisines.remove(cuisine);
    } else {
      selectedCuisines.add(cuisine);
    }
  }

  void applyFilters() {
    fetchRestaurants(reset: true);
  }
}
