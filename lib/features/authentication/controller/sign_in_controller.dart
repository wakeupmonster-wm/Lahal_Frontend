import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';

class SignInController extends GetxController {
  //----------------var / controllers----------------
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController(
    text: "+61",
  ); // Default AU
  final RxBool rememberMe = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //----------------helper functions----------------

  @override
  void onClose() {
    phoneNumberController.dispose();
    countryCodeController.dispose();
    super.onClose();
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  //----------------Api call----------------
  void onGetStarted(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.push(
        AppRoutes.otpVerify,
        extra: {
          'mode': AuthEntryMode.phone,
          'data': "${countryCodeController.text} ${phoneNumberController.text}",
        },
      );
    }
  }
}
