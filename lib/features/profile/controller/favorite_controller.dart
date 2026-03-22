import 'package:get/get.dart';
import '../model/favorite_restaurant_model.dart';
import '../repo/profile_repository.dart';
import '../../home/controller/location_controller.dart';

class FavoriteController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final LocationController _locationController = Get.find<LocationController>();

  final RxList<FavoriteRestaurantModel> favoriteRestaurants =
      <FavoriteRestaurantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
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
          data.map((x) => FavoriteRestaurantModel.fromJson(x)).toList(),
        );
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchFavorites();
  }
}
