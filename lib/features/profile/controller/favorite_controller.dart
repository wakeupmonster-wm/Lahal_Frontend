import 'package:get/get.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';

class FavoriteController extends GetxController {
  final HomeRepository _homeRepo = HomeRepository();

  final RxList<RestaurantModel> favoriteRestaurants = <RestaurantModel>[].obs;
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
      final restaurants = await _homeRepo.fetchFavoriteRestaurants();
      favoriteRestaurants.assignAll(restaurants);
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
