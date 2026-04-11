import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/services/home_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class SearchRestaurantsController extends GetxController {
  late final HomeService _homeService;
  
  final TextEditingController searchController = TextEditingController();

  final RxList<RestaurantModel> searchResults = <RestaurantModel>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = "".obs;
  
  // Custom states
  final RxBool hasSearched = false.obs; // To know when to switch from "Start searching" to "No Results"
  
  final RxString searchQuery = ''.obs;
  Timer? _searchDebounce;
  
  // Pagination
  int _currentPage = 1;
  final int _pageLimit = 20;
  bool _hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    _homeService = Get.find<HomeService>();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      _searchDebounce?.cancel();
      searchQuery.value = '';
      hasSearched.value = false;
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery.value = query.trim();
      hasSearched.value = true;
      performSearch(reset: true);
    });
  }

  Future<void> performSearch({bool reset = false}) async {
    if (searchQuery.value.trim().isEmpty) return;
    
    if (reset) {
      _currentPage = 1;
      _hasMoreData = true;
      searchResults.clear();
      isSearching.value = true;
    }

    if (!_hasMoreData) return;

    // Use current Location
    double? lat;
    double? lng;
    try {
      final locationController = Get.find<LocationController>();
      if (locationController.hasLocation.value) {
        lat = locationController.latitude.value;
        lng = locationController.longitude.value;
      }
    } catch (_) {}

    AppLogger.d('SearchRestaurantsController', 'Searching for "${searchQuery.value}" at ($lat, $lng)');

    _homeService.loadRestaurants(
      page: _currentPage,
      limit: _pageLimit,
      search: searchQuery.value,
      // lat: lat,
      // lng: lng,
      isLoading: _currentPage == 1 ? isSearching : isLoadingMore,
      errorMessage: errorMessage,
      onSuccess: (restaurants, metadata) {
        if (_currentPage == 1) {
          searchResults.assignAll(restaurants);
        } else {
          searchResults.addAll(restaurants);
        }
        _hasMoreData = metadata.hasMore;
        _currentPage++;
      },
      onError: (error) {
        AppLogger.e('SearchRestaurantsController', 'Failed to search restaurants', error);
      },
    );
  }

  void loadMoreRestaurants() {
    if (!isLoadingMore.value && _hasMoreData && !isSearching.value) {
      performSearch();
    }
  }

  void toggleFavorite(String restaurantId) {
    // We synchronize this optimistic UI toggle for the search screen
    final index = searchResults.indexWhere((r) => r.id == restaurantId);
    if (index == -1) return;

    final restaurant = searchResults[index];
    final isCurrentlyFavorite = restaurant.isFavourite;

    searchResults[index] = restaurant.copyWith(
      isFavourite: !isCurrentlyFavorite,
    );
    searchResults.refresh();

    if (isCurrentlyFavorite) {
      _homeService.removeFavorite(
        restaurantId: restaurantId,
        isLoading: false.obs,
        errorMessage: ''.obs,
        onSuccess: (message) => AppSnackBar.showToast(message: message),
        onError: (error) {
          searchResults[index] = restaurant.copyWith(isFavourite: isCurrentlyFavorite);
          searchResults.refresh();
          AppSnackBar.showToast(message: 'Failed to remove from favorites');
        },
      );
    } else {
      _homeService.addFavorite(
        restaurantId: restaurantId,
        isLoading: false.obs,
        errorMessage: ''.obs,
        onSuccess: (message) => AppSnackBar.showToast(message: message),
        onError: (error) {
          searchResults[index] = restaurant.copyWith(isFavourite: isCurrentlyFavorite);
          searchResults.refresh();
          AppSnackBar.showToast(message: 'Failed to add to favorites');
        },
      );
    }
  }
}
