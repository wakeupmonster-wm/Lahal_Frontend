import 'package:get/get.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/restaurant_repository.dart';

class RestaurantDetailsController extends GetxController {
  final RestaurantRepository _repository = RestaurantRepository();

  final Rxn<RestaurantModel> restaurant = Rxn<RestaurantModel>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // In a real app, we'd get the ID from the arguments
    // For now, we'll fetch a mock restaurant
    fetchRestaurantDetails('mock_id_123');
  }

  Future<void> fetchRestaurantDetails(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _repository.getRestaurantDetails(id);
      restaurant.value = data;
    } catch (e) {
      error.value = 'Failed to load restaurant details';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite() {
    // Logic to toggle favorite status
  }

  void shareRestaurant() {
    // Logic to share restaurant
  }

  void callRestaurant() {
    // Logic to trigger a phone call
  }

  void getDirections() {
    // Logic to open maps for directions
  }
}
