import 'dart:io';
import 'package:get/get.dart';
import 'package:lahal_application/features/add_restaurant/repo/add_restaurant_repository.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';

class AddRestaurantApiService extends GetxService {
  late final AddRestaurantRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<AddRestaurantRepository>();
  }

  void submitRestaurantRequest({
    required Map<String, String> fields,
    required Map<String, List<File>> multipartFiles,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call(
      apiCall: () => _repository.addRestaurantRequest(
        fields: fields,
        multipartFiles: multipartFiles,
      ),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
