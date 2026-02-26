import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  final RxList<RestaurantModel> bestRestaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = "".obs;

  // --- Filter State ---
  final RxDouble distanceRange = 200.0.obs;
  final RxInt rating = 0.obs;
  final RxString selectedCategory = 'Near you'.obs;

  @override
  void onInit() {
    super.onInit();
    getBestRestaurants();
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    // For now, we just refresh all restaurants.
    // In a real app, you'd filter by category here.
    getBestRestaurants();
  }

  void updateDistanceRange(double value) {
    distanceRange.value = value;
  }

  void updateRating(int value) {
    rating.value = value;
  }

  void clearFilters() {
    distanceRange.value = 200.0;
    rating.value = 0;
  }

  void applyFilters() {
    // Logic to apply filters and fetch data
    getBestRestaurants();
  }

  Future<void> getBestRestaurants() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      final result = await _repository.fetchBestRestaurants();

      if (selectedCategory.value == 'Near you') {
        bestRestaurants.assignAll(result);
      } else if (selectedCategory.value == 'Open now') {
        bestRestaurants.assignAll(
          result.where((r) => r.status == 'Open now').toList(),
        );
      } else if (selectedCategory.value == 'Top rated') {
        bestRestaurants.assignAll(
          result.where((r) => r.rating >= 4.5).toList(),
        );
      } else {
        bestRestaurants.assignAll(result);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
