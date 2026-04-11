import 'package:get/get.dart';
import 'package:lahal_application/features/profile/services/profile_api_service.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';
import 'package:lahal_application/features/profile/model/cms_model.dart'; // Add this import

class CmsService extends GetxService {
  late final ProfileApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ProfileApiService>();
  }

  void loadTermsAndConditions({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(CmsModel model) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.fetchTermsAndConditions(
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        try {
          final rawData = response.data;
          // Extract nested data if present
          final data = (rawData is Map<String, dynamic>)
              ? (rawData['data'] ?? rawData)
              : rawData;

          if (data != null && data is Map<String, dynamic>) {
            final model = CmsModel.fromJson(data);
            AppLogger.i(
              'CmsService',
              'Successfully parsed Terms and Conditions',
            );
            onSuccess(model);
          } else {
            AppLogger.w('CmsService', 'Terms data format mismatch or null');
            onSuccess(CmsModel.empty());
          }
        } catch (e) {
          AppLogger.e('CmsService', 'Error parsing Terms and Conditions', e);
          onError?.call(e);
        }
      },
      onError: (error) {
        AppLogger.e(
          'CmsService',
          'Failed to fetch Terms and Conditions',
          error,
        );
        onError?.call(error);
      },
    );
  }

  void loadPrivacyPolicy({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(CmsModel model) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.fetchPrivacyPolicy(
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        try {
          final rawData = response.data;
          // Extract nested data if present
          final data = (rawData is Map<String, dynamic>)
              ? (rawData['data'] ?? rawData)
              : rawData;

          if (data != null && data is Map<String, dynamic>) {
            final model = CmsModel.fromJson(data);
            AppLogger.i('CmsService', 'Successfully parsed Privacy Policy');
            onSuccess(model);
          } else {
            AppLogger.w('CmsService', 'Privacy data format mismatch or null');
            onSuccess(CmsModel.empty());
          }
        } catch (e) {
          AppLogger.e('CmsService', 'Error parsing Privacy Policy', e);
          onError?.call(e);
        }
      },
      onError: (error) {
        AppLogger.e('CmsService', 'Failed to fetch Privacy Policy', error);
        onError?.call(error);
      },
    );
  }
}
