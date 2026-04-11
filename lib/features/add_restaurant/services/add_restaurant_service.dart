import 'dart:io';
import 'package:get/get.dart';
import 'package:lahal_application/features/add_restaurant/services/add_restaurant_api_service.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';
import 'package:lahal_application/data/models/api_response.dart';

class AddRestaurantService extends GetxService {
  late final AddRestaurantApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<AddRestaurantApiService>();
  }

  void submitRequest({
    required Map<String, String> fields,
    required Map<String, List<File>> multipartFiles,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.submitRestaurantRequest(
      fields: fields,
      multipartFiles: multipartFiles,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        AppLogger.i(
          'AddRestaurantService',
          'Restaurant request submitted successfully',
        );
        onSuccess(response);
      },
      onError: (error) {
        AppLogger.e(
          'AddRestaurantService',
          'Failed to submit restaurant request',
          error,
        );
        onError?.call(error);
      },
    );
  }
}
