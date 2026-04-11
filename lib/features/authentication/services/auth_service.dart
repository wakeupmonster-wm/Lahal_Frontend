import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
          String rawOtp = "";
          try {
            if (response.data != null && response.data is Map) {
              final otp = response.data['otp'];
              if (otp != null) {
                rawOtp = otp.toString();
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

          if (rawOtp.isNotEmpty) {
            // Show dialog for testing purposes when using test endpoint
            // Introduce a small delay so the page transition finishes before the dialog opens.
            Future.delayed(const Duration(milliseconds: 500), () {
              // We use the root navigator context to ensure it remains valid after push.
              final rootContext = AppGoRouter.navigatorKey.currentContext;
              if (rootContext != null && rootContext.mounted) {
                showDialog(
                  context: rootContext,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Test OTP'),
                      content: Text(
                        'Your OTP is: $rawOtp\n\n(This dialog is for testing purposes only)',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: rawOtp)).then((
                              _,
                            ) {
                              AppSnackBar.showToast(
                                message: 'OTP copied to clipboard',
                              );
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                            });
                          },
                          child: const Text('Copy'),
                        ),
                      ],
                    );
                  },
                );
              }
            });
          } else {
            print("---------- else block ----------");
            // Normal flow for real endpoint when OTP isn't exposed
            AppSnackBar.showToast(
              message: navigateToVerify
                  ? "OTP Sent Successfully"
                  : "OTP Resent Successfully",
            );
          }
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

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  /// Triggers the Google account-picker (sign out first so it always shows),
  /// obtains the ID token, and exchanges it with our backend for app tokens.
  ///
  /// Uses a [Completer] to bridge the v7 stream-based API into an
  /// async/await flow. The subscription is set up BEFORE [authenticate()] is
  /// called to ensure no events are missed.
  Future<void> handleGoogleLogin({required BuildContext context}) async {
    final googleSignIn = GoogleSignIn.instance;

    try {
      // Disconnect first so the account chooser always appears.
      await googleSignIn.disconnect().catchError((_) {});

      // Set up a completer to await the sign-in result from the event stream.
      final completer = Completer<GoogleSignInAccount>();
      late final StreamSubscription<GoogleSignInAuthenticationEvent> sub;

      sub = googleSignIn.authenticationEvents.listen(
        (event) {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            if (!completer.isCompleted) {
              completer.complete(event.user);
            }
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            if (!completer.isCompleted) {
              completer.completeError(
                Exception('Sign out received instead of sign in'),
              );
            }
          }
          sub.cancel();
        },
        onError: (Object e) {
          if (!completer.isCompleted) completer.completeError(e);
          sub.cancel();
        },
        cancelOnError: true,
      );

      // Trigger the account picker. On Android this returns after the user
      // picks an account (or cancels, throwing a GoogleSignInException).
      await googleSignIn.authenticate();

      // Wait for the stream to emit the sign-in event.
      final account = await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          sub.cancel();
          throw Exception('Google sign-in timed out');
        },
      );

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        AppLogger.e('AuthService', 'Google idToken is null', null);
        AppSnackBar.showToast(
          message: 'Google Sign-In failed. Please try again.',
        );
        return;
      }

      AppLogger.i('AuthService', 'Google idToken obtained, calling backend');

      if (!context.mounted) return;

      _apiService.googleLogin(
        payload: {'token': idToken},
        isLoading: _stateService.isGoogleSigningIn,
        errorMessage: _stateService.errorMessage,
        onSuccess: (response) async {
          AppLogger.i(
            'AuthService',
            'Google login backend success: ${response.message}',
          );
          try {
            final data = response.data as Map<String, dynamic>;
            final userJson = data['user'] as Map<String, dynamic>;
            final authJson = data['auth'] as Map<String, dynamic>;

            final userPref = UserPreferences();
            await userPref.setToken(authJson['accessToken']);
            await userPref.setRefreshToken(authJson['refreshToken']);

            final userModel = UserModel.fromJson(userJson);
            await userPref.setUser(userModel);

            final rootContext = AppGoRouter.navigatorKey.currentContext;
            if (rootContext != null && rootContext.mounted) {
              rootContext.go(AppRoutes.bottomNavigationBar);
            }
          } catch (e, stack) {
            AppLogger.e(
              'AuthService',
              'Failed to parse Google login response',
              e,
              stack,
            );
            AppSnackBar.showToast(
              message: 'An error occurred. Please try again.',
            );
          }
        },
        onError: (error) {
          AppLogger.e('AuthService', 'Google login backend failed', error);
          final rootContext = AppGoRouter.navigatorKey.currentContext;
          if (rootContext != null && rootContext.mounted) {
            AppSnackBar.showSnackbar(
              context: rootContext,
              title: 'Google Sign-In Failed',
              message: error.toString(),
            );
          }
        },
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User dismissed the picker — not an error.
        AppLogger.i('AuthService', 'Google sign-in cancelled by user');
        return;
      }
      AppLogger.e('AuthService', 'Google sign-in exception', e);
      AppSnackBar.showToast(
        message: 'Google Sign-In failed. Please try again.',
      );
    } on PlatformException catch (e) {
      AppLogger.e('AuthService', 'Google sign-in PlatformException', e);
      AppSnackBar.showToast(message: 'Google Sign-In failed: ${e.message}');
    } catch (e) {
      AppLogger.e('AuthService', 'Google sign-in unexpected error', e);
      AppSnackBar.showToast(
        message: 'Google Sign-In failed. Please try again.',
      );
    }
  }
}
