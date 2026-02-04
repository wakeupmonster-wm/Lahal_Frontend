import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/authentication/repo/auth_repositories.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
// import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';

class SignInController extends GetxController {
  //------------------------var / controllers----------------
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController(
    text: "+61",
  ); // Default AU
  final RxBool rememberMe = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _authRepo = AuthRepositories();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  //------------------------helper functions----------------

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

  //-----------------------------Api call---------------------
  void onGetStarted(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // NOTE: API is not complete yet, so these codes are commented out as per instructions.
      // Uncomment and adjust when API is ready.

      /*
      ApiCallHandler().apiHandler(
        context: context,
        apiCall: () => _authRepo.signIn({
          'country_code': countryCodeController.text,
          'phone_number': phoneNumberController.text,
        }),
        isLoading: isLoading,
        errorMessage: errorMessage,
        onSuccess: (result) {
          // Handle success response, e.g., save tokens if any
          context.push(
            AppRoutes.otpVerify,
            extra: {
              'mode': AuthEntryMode.phone,
              'data': "${countryCodeController.text} ${phoneNumberController.text}",
            },
          );
        },
      );
      */

      // Temporary navigation for testing UI flow
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
