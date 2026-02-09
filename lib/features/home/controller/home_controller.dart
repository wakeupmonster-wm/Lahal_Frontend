import 'package:get/get.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  final RxList<RestaurantModel> bestRestaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
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
