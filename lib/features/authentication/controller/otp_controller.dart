import 'dart:async';
import 'package:get/get.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  // reactive OTP string
  final RxString otp = ''.obs;

  // loading state while verifying
  final RxBool isLoading = false.obs;

  // countdown timer
  final RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  // length of OTP expected
  final int length;

  OtpController({this.length = 6});

  // computed helper
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

  /// Called by OTP widget when full code available
  void setOtp(String code) {
    otp.value = code.trim();
    if (isComplete) {
      verifyOtp(); // Auto-verify when filled? Based on UX patterns usually yes or user clicks button.
      // User image has no Verify button, only "Go Back". So auto-verify is likely.
    }
  }

  /// Called by individual digit widgets if you want to update each change.
  void updatePartialOtp(String partial) {
    otp.value = partial;
  }

  // After Verification go to Inital State
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

  /// Verify the OTP (fake network call for now)
  Future<void> verifyOtp() async {
    if (!isComplete || isLoading.value) return;
    try {
      isLoading.value = true;

      // simulate network latency
      await Future.delayed(const Duration(seconds: 2));

      // --- SUCCESS ---
      isLoading.value = false;

      // show a snackbar or do navigation, whatever you need
      AppSnackBar.showToast(message: 'OTP verified');

      // Clear OTP
      reset();

      // TODO: navigate to next screen or call auth success flow
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.showToast(message: 'Verification failed');
    }
  }

  /// Resend OTP: triggers server call and resets UI timer if needed.
  Future<void> resendOtp() async {
    if (remainingSeconds.value > 0) return;

    try {
      // fake network call
      await Future.delayed(const Duration(seconds: 1));
      AppSnackBar.showToast(message: 'OTP resent');

      // reset internal OTP (optional)
      otp.value = '';

      startTimer();
    } catch (e) {
      AppSnackBar.showToast(message: 'Resend failed');
    }
  }
}
