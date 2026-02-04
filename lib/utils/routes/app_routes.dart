part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  //======================= SPLASH  ============================
  static const String splashScreen = '/splash-screen';

  //======================= AUTHENTICATION ====================
  static const String signInScreen = '/sign-in-screen';
  static const String otpVerify = '/otp-verification-screen';

  //======================= HOME ==================
  static const String homeScreen = '/home_screen';
  static const String mapScreen = '/map_screen';
  static const String preyScreen = '/prey_screen';
  static const String profileScreen = '/profile_screen';

  ///===============   Bottmsheet ======================
  static const String bottomNavigationBar = '/bottomNavigationBar';
}
