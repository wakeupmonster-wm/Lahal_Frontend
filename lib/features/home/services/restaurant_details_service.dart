import 'package:get/get.dart';
import 'package:lahal_application/features/home/services/restaurant_details_api_service.dart';
import 'package:lahal_application/features/home/model/restaurant_details_model.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class RestaurantDetailsService extends GetxService {
  late final RestaurantDetailsApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<RestaurantDetailsApiService>();
  }

  void loadRestaurantDetails({
    required String restaurantId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(RestaurantDetailsModel details) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.getRestaurantDetails(
      restaurantId: restaurantId,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        if (response.data != null) {
          AppLogger.i('RestaurantDetailsService', 'Fetched details for ID: $restaurantId');
          onSuccess(response.data!);
        } else {
          AppLogger.w('RestaurantDetailsService', 'Response data was null');
          // Trigger error manually if data is null but request succeeded
          if (onError != null) {
            onError('No details found.');
          } else {
             errorMessage.value = 'No details found.';
          }
        }
      },
      onError: (error) {
        AppLogger.e('RestaurantDetailsService', 'Failed to load details', error);
        onError?.call(error);
      },
    );
  }
}
