import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:lahal_application/features/authentication/services/auth_service.dart';

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  //------------------------var / controllers----------------
  final RxString otp = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt remainingSeconds = 0.obs;
  Timer? _timer;
  final int length;
  final String phone; // Phone passed directly from sign-in screen

  // Pinput controller — lets us programmatically fill from SMS
  final TextEditingController pinputController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final smartAuth = SmartAuth.instance;

  OtpController({this.length = 6, required this.phone});

  //------------------------helper functions----------------
  bool get isComplete => otp.value.length == length;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    _listenForSmsOtp();
    // Ensure focus is explicitly requested after transition completes
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!focusNode.hasFocus) {
        focusNode.requestFocus();
      }
    });
  }

  void _listenForSmsOtp() async {
    try {
      final res = await smartAuth.getSmsWithUserConsentApi();
      if (res.hasData) {
        final code = res.requireData.code;
        if (code != null) {
          // Fill Pinput controller — it will fire onCompleted automatically
          pinputController.setText(code);
          otp.value = code;
        }
      } else if (res.isCanceled) {
        debugPrint('SmartAuth: user dismissed OTP consent dialog');
      }
    } catch (e) {
      debugPrint('SmartAuth Error: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinputController.dispose();
    focusNode.dispose();
    smartAuth.removeUserConsentApiListener();
    super.onClose();
  }

  void setOtp(String code, BuildContext context) {
    otp.value = code.trim();
    if (isComplete) {
      verifyOtp(context);
    }
  }

  void reset() {
    otp.value = '';
    pinputController.clear();
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
    if (!isComplete) return;

    final authService = Get.find<AuthService>();

    authService.handleVerifyOtp(
      payload: {
        'phone': phone, // Use constructor-injected phone — never empty
        'otp': otp.value,
      },
      context: context,
    );
  }

  //----------------------------------------resend otp api call--------------------------------

  Future<void> resendOtp(BuildContext context) async {
    if (remainingSeconds.value > 0 || isLoading.value) return;

    final authService = Get.find<AuthService>();

    authService.handleSendOtp(
      payload: {'phone': phone},
      context: context,
      navigateToVerify: false,
    );

    reset();
    startTimer();
    _listenForSmsOtp();
  }
}
