import 'package:get/get.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';

class CmsController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();

  // Terms & Conditions
  final RxString termsData = "".obs;
  final RxBool isTermsLoading = false.obs;

  // Privacy Policy
  final RxString privacyData = "".obs;
  final RxBool isPrivacyLoading = false.obs;

  Future<void> fetchTerms() async {
    isTermsLoading.value = true;
    try {
      final response = await _profileRepo.getTermsAndConditions();
      if (response.isSuccess) {
        termsData.value = response.data.toString();
      }
    } finally {
      isTermsLoading.value = false;
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    isPrivacyLoading.value = true;
    try {
      final response = await _profileRepo.getPrivacyPolicy();
      if (response.isSuccess) {
        privacyData.value = response.data.toString();
      }
    } finally {
      isPrivacyLoading.value = false;
    }
  }
}
