import 'package:get/get.dart';
import 'package:lahal_application/features/profile/services/cms_service.dart';
import 'package:lahal_application/features/profile/model/cms_model.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/features/profile/services/profile_api_service.dart';

class CmsController extends GetxController {
  late final CmsService _cmsService;

  // State Management
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  // CMS Data
  final Rx<CmsModel> termsData = CmsModel.empty().obs;
  final Rx<CmsModel> privacyData = CmsModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure dependencies are registered
    if (!Get.isRegistered<ProfileRepository>()) Get.put(ProfileRepository());
    if (!Get.isRegistered<ProfileApiService>()) Get.put(ProfileApiService());
    if (!Get.isRegistered<CmsService>()) Get.put(CmsService());

    _cmsService = Get.find<CmsService>();
  }

  void fetchTerms() {
    _cmsService.loadTermsAndConditions(
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (model) {
        termsData.value = model;
      },
      onError: (error) {
        errorMessage.value = error.toString();
      },
    );
  }

  void fetchPrivacyPolicy() {
    _cmsService.loadPrivacyPolicy(
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (model) {
        privacyData.value = model;
      },
      onError: (error) {
        errorMessage.value = error.toString();
      },
    );
  }

  // Helper to clear errors
  void clearError() {
    errorMessage.value = "";
  }
}
