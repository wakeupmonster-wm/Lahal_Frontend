import 'dart:developer';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/services/home_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import '../model/favorite_restaurant_model.dart';
import '../repo/profile_repository.dart';
import '../../home/controller/location_controller.dart';

class FavoriteController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final LocationController _locationController = Get.find<LocationController>();
  HomeService get _homeService => Get.find<HomeService>();

  final RxList<FavoriteRestaurantModel> favoriteRestaurants =
      <FavoriteRestaurantModel>[].obs;
  final RxList<String> removingIds = <String>[].obs; // Track IDs being removed
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<HomeService>()) {
      Get.put(HomeService());
    }
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await _profileRepo.getFavoriteRestaurants(
        lat: _locationController.latitude.value,
        lng: _locationController.longitude.value,
      );
      if (response.isSuccess) {
        final List<dynamic> data = response.data as List<dynamic>;
        favoriteRestaurants.assignAll(
          data.map((x) {
            try {
              return FavoriteRestaurantModel.fromJson(x);
            } catch (e) {
              log("Error parsing favorite restaurant: $e, Data: $x");
              rethrow;
            }
          }).toList(),
        );
      } else {
        log("API Error in fetchFavorites: ${response.message}");
        hasError.value = true;
      }
    } catch (e) {
      log("Catch Error in fetchFavorites: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String restaurantId) async {
    if (removingIds.contains(restaurantId)) return;

    final index = favoriteRestaurants.indexWhere((r) => r.id == restaurantId);
    if (index == -1) return;

    final favorite = favoriteRestaurants[index];

    // 1. Mark as removing to trigger animation
    removingIds.add(restaurantId);

    // 2. Wait for the slide/fade animation to complete
    await Future.delayed(const Duration(milliseconds: 350));

    // 3. Actually remove from list
    favoriteRestaurants.removeAt(index);
    removingIds.remove(restaurantId);

    // 4. API Request
    _homeService.removeFavorite(
      restaurantId: restaurantId,
      isLoading: false.obs,
      errorMessage: "".obs,
      onSuccess: (message) {
        AppSnackBar.showToast(message: message);
      },
      onError: (error) {
        // Revert optimistic update if API fails
        favoriteRestaurants.insert(index, favorite);
        AppSnackBar.showToast(message: "Failed to remove from favorites");
      },
    );
  }

  Future<void> onRefresh() async {
    await fetchFavorites();
  }
}
