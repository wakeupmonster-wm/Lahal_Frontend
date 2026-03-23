import 'package:get/get.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/features/home/repo/report_error_repository.dart';

class ReportErrorApiService extends GetxService {
  late final ReportErrorRepository _repository;
  
  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<ReportErrorRepository>();
  }

  void submitReport({
    required String restaurantId,
    required List<String> reasons,
    required String message,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<dynamic> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<dynamic>(
      apiCall: () => _repository.submitReport(
        restaurantId: restaurantId,
        reasons: reasons,
        message: message,
      ),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
