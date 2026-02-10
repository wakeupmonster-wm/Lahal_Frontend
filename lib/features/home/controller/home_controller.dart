import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
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
      bestRestaurants.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
