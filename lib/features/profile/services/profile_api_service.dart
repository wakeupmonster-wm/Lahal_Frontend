import 'package:get/get.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';

class ProfileApiService extends GetxService {
  late final ProfileRepository _profileRepo;

  @override
  void onInit() {
    super.onInit();
    _profileRepo = Get.find<ProfileRepository>();
  }

  void fetchFaqs({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call(
      apiCall: () => _profileRepo.getFaqs(),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  void fetchTermsAndConditions({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call(
      apiCall: () => _profileRepo.getTermsAndConditions(),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  void fetchPrivacyPolicy({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call(
      apiCall: () => _profileRepo.getPrivacyPolicy(),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
