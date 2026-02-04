import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/features/authentication/repo/auth_repositories.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  //------------------------var / controllers----------------
  final RxString otp = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt remainingSeconds = 0.obs;
  Timer? _timer;
  final int length;
  final _authRepo = AuthRepositories();
  OtpController({this.length = 6});

  //------------------------helper functions----------------
  bool get isComplete => otp.value.length == length;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void setOtp(String code, BuildContext context) {
    otp.value = code.trim();
    if (isComplete) {
      verifyOtp(context);
    }
  }

  void updatePartialOtp(String partial) {
    otp.value = partial;
  }

  void reset() {
    otp.value = '';
    isLoading.value = false;
  }

  void startTimer() {
    remainingSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  //-------------------------------------- verify otp Api call---------------------

  Future<void> verifyOtp(BuildContext context) async {
    if (!isComplete || isLoading.value) return;

    /*
    ApiCallHandler().apiHandler(
      context: Get.context!, // Using Get.context for convenience, though passing context is better
      apiCall: () => _authRepo.verifyOtp({
        'otp': otp.value,
      }),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (result) {
        AppSnackBar.showToast(message: 'OTP verified');
        reset();
        // TODO: navigate to next screen
      },
      onError: (error, stack) {
        AppSnackBar.showToast(message: 'Verification failed');
      },
    );
    */

    //testttttt
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;
      AppSnackBar.showToast(message: 'OTP verified (Mock)');
      reset();
      context.go(AppRoutes.bottomNavigationBar);
      // Get.context?.go(AppRoutes.bottomNavigationBar);
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.showToast(message: 'Verification failed');
    }
  }

  //----------------------------------------resend otp api call--------------------------------

  Future<void> resendOtp() async {
    if (remainingSeconds.value > 0 || isLoading.value) return;

    /*
    ApiCallHandler().apiHandler(
      context: Get.context!,
      apiCall: () => _authRepo.resendOtp({}),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (result) {
        AppSnackBar.showToast(message: 'OTP resent');
        otp.value = '';
        startTimer();
      },
    );
    */

    //  TESTING
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
      AppSnackBar.showToast(message: 'OTP resent (Mock)');
      otp.value = '';
      startTimer();
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.showToast(message: 'Resend failed');
    }
  }
}
