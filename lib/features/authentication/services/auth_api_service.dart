import 'package:get/get.dart';
import 'package:lahal_application/features/authentication/repo/auth_repositories.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/utils/services/helper/debouncing.dart';

class AuthApiService extends GetxService {
  late final AuthRepositories _authRepo;
  final AppDebouncer _debouncer = AppDebouncer(milliseconds: 500); //   final AppDebouncer _debouncer = AppDebouncer(milliseconds: 100);

  @override
  void onInit() {
    super.onInit();
    _authRepo = Get.find<AuthRepositories>();
  }

  void sendOtp({
    required Map<String, dynamic> payload,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) {
    _debouncer.run(() async {
      await ApiCallHandler.call(
        apiCall: () => _authRepo.sendOtp(payload),
        isLoading: isLoading,
        errorMessage: errorMessage,
        onSuccess: onSuccess,
        onError: onError,
      );
    });
  }

  void verifyOtp({
    required Map<String, dynamic> payload,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) {
    _debouncer.run(() async {
      await ApiCallHandler.call(
        apiCall: () => _authRepo.verifyOtp(payload),
        isLoading: isLoading,
        errorMessage: errorMessage,
        onSuccess: onSuccess,
        onError: onError,
      );
    });
  }
}
