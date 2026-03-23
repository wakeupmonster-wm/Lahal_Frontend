import 'package:get/get.dart';
import 'package:lahal_application/features/home/repo/restaurant_details_repository.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/features/home/model/restaurant_details_model.dart';

class RestaurantDetailsApiService extends GetxService {
  late final RestaurantDetailsRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<RestaurantDetailsRepository>();
  }

  void getRestaurantDetails({
    required String restaurantId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<RestaurantDetailsModel> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<RestaurantDetailsModel>(
      apiCall: () => _repo.getRestaurantDetails(restaurantId),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
