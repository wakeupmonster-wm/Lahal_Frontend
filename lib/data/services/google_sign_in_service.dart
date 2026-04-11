import 'dart:async';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

/// A GetX service that initialises [GoogleSignIn] once during app startup
/// and maintains the singleton lifecycle.
///
/// Register this in [main()] via [Get.putAsync] or [Get.put] BEFORE any
/// other service that uses [GoogleSignIn.instance].
class GoogleSignInService extends GetxService {
  // Current signed-in Google account (null if not signed in).
  final Rxn<GoogleSignInAccount> currentUser = Rxn<GoogleSignInAccount>();

  late final StreamSubscription<GoogleSignInAuthenticationEvent> _eventSub;

  @override
  void onInit() {
    super.onInit();
    _initGoogleSignIn();
  }

  Future<void> _initGoogleSignIn() async {
    try {
      // initialize() must be called exactly once. Passing no clientId lets
      // the platform use the value from google-services.json (Android) or
      // GoogleService-Info.plist (iOS).
      await GoogleSignIn.instance.initialize();

      // Listen for authentication events to keep [currentUser] in sync.
      _eventSub = GoogleSignIn.instance.authenticationEvents.listen(
        _handleAuthEvent,
        onError: (Object e) {
          AppLogger.e('GoogleSignInService', 'Auth event stream error', e);
        },
      );

      // Attempt a silent / lightweight sign-in on startup so existing
      // sessions are restored without showing the picker.
      GoogleSignIn.instance.attemptLightweightAuthentication();
    } catch (e, stack) {
      AppLogger.e('GoogleSignInService', 'GoogleSignIn initialization failed', e, stack);
    }
  }

  void _handleAuthEvent(GoogleSignInAuthenticationEvent event) {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      currentUser.value = event.user;
      AppLogger.i(
        'GoogleSignInService',
        'Google account signed in: ${event.user.email}',
      );
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      currentUser.value = null;
      AppLogger.i('GoogleSignInService', 'Google account signed out');
    }
  }

  @override
  void onClose() {
    _eventSub.cancel();
    super.onClose();
  }
}
