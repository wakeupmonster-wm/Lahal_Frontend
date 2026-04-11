import 'package:get/get.dart';
import 'package:lahal_application/features/profile/services/profile_api_service.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';
import 'package:lahal_application/features/profile/model/faq_model.dart';

class FaqService extends GetxService {
  late final ProfileApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ProfileApiService>();
  }

  void loadFaqs({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(List<FaqModel> faqs) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.fetchFaqs(
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        final data = response.data;
        if (data != null && data is List) {
          final faqs = data.map((json) => FaqModel.fromJson(json)).toList();
          AppLogger.i('FaqService', 'Fetched ${faqs.length} FAQs');
          onSuccess(faqs);
        } else {
          AppLogger.w('FaqService', 'Response data was null or not a list');
          onSuccess([]);
        }
      },
      onError: (error) {
        AppLogger.e('FaqService', 'Failed to load FAQs', error);
        onError?.call(error);
      },
    );
  }
}
