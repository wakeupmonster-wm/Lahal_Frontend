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
  static const String restaurantDetails = '/restaurant_details';
  static const String notificationScreen = '/notification_screen';
  //========================profile==================
  static const String accountManagement = '/account_management';
  static const String changeLocationScreen = '/change_location_screen';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String aboutScreen = '/about_screen';
  static const String termsScreen = '/terms_screen';
  static const String privacyScreen = '/privacy_screen';
  static const String faqScreen = '/faq_screen';
  static const String notificationPreferenceScreen =
      '/notification_preference_screen';
  static const String favoritesScreen = '/favorites_screen';
  static const String reportErrorScreen = '/report_error_screen';

  ///===============   Bottmsheet ======================
  static const String bottomNavigationBar = '/bottomNavigationBar';
}
