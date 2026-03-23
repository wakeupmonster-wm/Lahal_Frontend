import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/data/datasources/local/user_prefrence.dart';
import 'package:lahal_application/features/authentication/models/user_model.dart';
import 'package:lahal_application/features/authentication/services/auth_api_service.dart';
import 'package:lahal_application/features/authentication/services/auth_state_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class AuthService extends GetxService {
  late final AuthApiService _apiService;
  late final AuthStateService _stateService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<AuthApiService>();
    _stateService = Get.find<AuthStateService>();
  }

  void handleSendOtp({
    required Map<String, dynamic> payload,
    required BuildContext context,
    bool navigateToVerify = true,
  }) {
    _apiService.sendOtp(
      payload: payload,
      isLoading: _stateService.isAuthenticating,
      errorMessage: _stateService.errorMessage,
      onSuccess: (response) {
        if (context.mounted) {
          AppLogger.i(
            'AuthService',
            'OTP sent successfully: ${response.message}',
          );

          // Extract OTP for testing if available
          String otpMessage = "";
          try {
            if (response.data != null && response.data is Map) {
              final otp = response.data['otp'];
              if (otp != null) {
                otpMessage = "Test OTP: $otp";
              }
            }
          } catch (_) {}

          // We wait until user goes in, then auto-fill takes over
          if (navigateToVerify) {
            context.push(
              AppRoutes.otpVerify,
              extra: {
                'mode': AuthEntryMode.phone,
                'data': "${payload['phone']}",
              },
            );
          }

          // AppSnackBar.showSnackbar(
          //   context: context,
          //   title: navigateToVerify ? "Otp Sent Successfully" : "Otp Resent Successfully",
          //   message: otpMessage,
          // );

          AppSnackBar.showToast(message: otpMessage);
        }
      },
      onError: (error) {
        if (context.mounted) {
          AppLogger.e('AuthService', 'Send OTP failed', error);
          // Show snackbar / dialog based on MAFS UI
          AppSnackBar.showSnackbar(
            context: context,
            title: "Otp Sent Failed",
            message: error.toString(),
          );
        }
      },
    );
  }

  void handleVerifyOtp({
    required Map<String, dynamic> payload,
    required BuildContext context,
  }) {
    _apiService.verifyOtp(
      payload: payload,
      isLoading: _stateService.isAuthenticating,
      errorMessage: _stateService.errorMessage,
      onSuccess: (response) async {
        if (context.mounted) {
          AppLogger.i(
            'AuthService',
            'OTP verification successful: ${response.message}',
          );

          // Parsing data
          try {
            final data = response.data as Map<String, dynamic>;
            final userJson = data['user'] as Map<String, dynamic>;
            final authJson = data['auth'] as Map<String, dynamic>;

            // Save Tokens and User Model
            final userPref = UserPreferences();
            await userPref.setToken(authJson['accessToken']);
            await userPref.setRefreshToken(authJson['refreshToken']);

            final userModel = UserModel.fromJson(userJson);
            await userPref.setUser(userModel);

            if (context.mounted) {
              // Usually go straight to NavigationScreen/Home
              context.go(AppRoutes.bottomNavigationBar);
            }
          } catch (e, stack) {
            AppLogger.e(
              'AuthService',
              'Failed to parse OTP response data',
              e,
              stack,
            );
          }
        }
      },
      onError: (error) {
        if (context.mounted) {
          AppLogger.e('AuthService', 'OTP Verification failed', error);
        }
        AppSnackBar.showSnackbar(
          context: context,
          title: "Otp Verification Failed",
          message: error.toString(),
        );
      },
    );
  }
}
