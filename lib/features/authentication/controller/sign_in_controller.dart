import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:lahal_application/features/authentication/repo/auth_repositories.dart';
import 'package:lahal_application/features/authentication/services/auth_api_service.dart';
import 'package:lahal_application/features/authentication/services/auth_service.dart';
import 'package:lahal_application/features/authentication/services/auth_state_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/validators/validators.dart';

class SignInController extends GetxController {
  //------------------------var / controllers----------------
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController(
    text: "+91" /*text: "+61"*/,
  ); // Default AU
  final RxBool rememberMe = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final AuthStateService stateService;

  final _smartAuth = SmartAuth.instance;

  @override
  void onInit() {
    super.onInit();

    // Inject MAFS standard dependencies manually if not handled by a feature orchestrator
    if (!Get.isRegistered<AuthRepositories>()) Get.put(AuthRepositories());
    if (!Get.isRegistered<AuthApiService>()) Get.put(AuthApiService());
    if (!Get.isRegistered<AuthStateService>()) Get.put(AuthStateService());
    if (!Get.isRegistered<AuthService>()) Get.put(AuthService());

    stateService = Get.find<AuthStateService>();

    // Android only: prompt user to pick their SIM phone number automatically
    // _requestPhoneHint(); // called conditionally later via requestPhoneHintIfNeeded
  }

  bool _hintRequested = false;

  void requestPhoneHintIfNeeded(BuildContext context) {
    if (!_hintRequested) {
      _hintRequested = true;
      _requestPhoneHint(context);
    }
  }

  void _requestPhoneHint(BuildContext context) async {
    try {
      final res = await _smartAuth.requestPhoneNumberHint();
      if (res.hasData) {
        final fullPhone = res.requireData; // e.g. "+918349020828"
        String parsedNumber = fullPhone;

        // Extract digits only, ignoring spaces, dashes, or plus signs
        String digitsOnly = fullPhone.replaceAll(RegExp(r'\D'), '');
        String countryCodeDigits = countryCodeController.text.replaceAll(RegExp(r'\D'), '');

        // Safely strip the country code if it is included in the hint
        if (countryCodeDigits.isNotEmpty &&
            digitsOnly.startsWith(countryCodeDigits) &&
            digitsOnly.length > countryCodeDigits.length + 5) {
          parsedNumber = digitsOnly.substring(countryCodeDigits.length);
        } else if (digitsOnly.length >= 10) {
          // Fallback: extract the last 10 digits as a robust default
          parsedNumber = digitsOnly.substring(digitsOnly.length - 10);
        } else {
          parsedNumber = digitsOnly;
        }

        final finalPhone = "${countryCodeController.text}$parsedNumber";

        if (context.mounted) {
          AppSnackBar.showSnackbar(
            context: context,
            title: "Number is : $finalPhone",
          );
        } else {
          AppSnackBar.showToast(message: "Context is not mounted");
        }

        final authService = Get.find<AuthService>();
        if (context.mounted) {
          authService.handleSendOtp(
            payload: {'phone': finalPhone},
            context: context,
          );
        }
      }
    } catch (e) {
      // Phone hint is a nice-to-have — silently ignore errors
      debugPrint('PhoneHint error: $e');
    }
  }

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
      // Manual Validation
      final phoneError = Validator.validatePhoneNumber(
        phoneNumberController.text,
        countryCode: countryCodeController.text,
      );

      if (phoneError != null) {
        stateService.errorMessage.value = phoneError;
        AppSnackBar.showToast(message: phoneError);
        return;
      }

      final authService = Get.find<AuthService>();

      authService.handleSendOtp(
        payload: {
          'phone': "${countryCodeController.text}${phoneNumberController.text}",
        },
        context: context,
      );
    }
  }
}
