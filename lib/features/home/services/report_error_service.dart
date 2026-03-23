import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/services/report_error_api_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';

class ReportErrorService extends GetxService {
  late final ReportErrorApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ReportErrorApiService>();
  }

  void submitReport({
    required String restaurantId,
    required List<String> reasons,
    required String message,
    required RxBool isLoading,
    required RxString errorMessage,
    required VoidCallback onSuccess,
    Function(String)? onError,
  }) {
    _apiService.submitReport(
      restaurantId: restaurantId,
      reasons: reasons,
      message: message,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        final msg = response.message.isNotEmpty ? response.message : 'Report submitted successfully';
        AppSnackBar.showToast(message: msg);
        onSuccess();
      },
      onError: (error) {
        if (onError != null) {
          onError(error.message);
        } else {
          AppSnackBar.showToast(message: error.message);
        }
      },
    );
  }
}
