part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  // ============ SPLASH  ============
  static const String splashScreen = '/splash-screen';

  // ============ AUTHENTICATION ============
  static const String signInScreen = '/sign-in-screen';
  static const String otpVerify = '/otp-verification-screen';

  //------------------------old code-------------------
  static const String authEntry = '/auth/entry';

  // ============ HOME & MAIN NAVIGATION ============
  static const String homeScreen = '/home-screen';
  static const String notificationScreen = '/notificationScreen';
  static const String notificationSettingScreen = '/notificationSettingScreen';
  static const String accountSecurityScreen = '/accountSecurityScreen';
  static const String subscriptionScrees = '/subscriptionScreen';
  static const String dataAnalyticsScreen = '/dataAnalyticsScreen';
  static const String profilePrivacyScreen = '/profilePrivacyScreen';
  static const String visibilityScreen = '/visibilityScreen';
  static const String usernameScreen = '/usernameScreen';
  static const String profileScreen = '/profile-screen';
  static const String blockedUsersScreen = '/blockedUsersScreen';
  static const String blockContactsScreen = '/blockContactsScreen';
  static const String helpAndSupportScreen = '/helpAndSupportScreen';
  static const String contactSupportScreen = '/contactSupportScreen';
  static const String termsConditionsScreen = '/termsConditionsScreen';
  static const String privacyPolicyScreenHelp = '/privacyPolicyScreenHelp';

  // ============ PROFILE SETUP ============

  // Profile setup (feature: profile_setup)
  static const onboardingsteps = '/onboarding/steps';
  static const profileEnterName = '/profile/step/0';
  static const profileDob = '/profile/step/1';
  static const profileYourIdentity = '/profile/step/2';
  static const profileRelationshipGoal = '/profile/step/3';
  static const profileInterestedIn = '/profile/step/4';
  static const profileAgeRange = '/profile/step/5';
  static const profileDistancePref = '/profile/step/6';
  static const profileInterests = '/profile/step/7';
  static const profileUploadPhotos = '/profile/step/8';
  static const profileSelfieVerify = '/profile/step/9';
  static const profileDocVerify = '/profile/step/10';

  // Optional: final review / dashboard
  static const profileReview = '/profile/review';

  // ============ PROFILE & SETTINGS ============
  static const String editProfileScreen = '/edit-profile-screen';
  static const String changePasswordScreen = '/change-password-screen';
  static const String termsAndConditionsScreen = '/terms-and-conditions-screen';
  static const String aboutAppScreen = '/about-app-screen';
  static const String faqScreen = '/faqScreen';
  static const String profileInterestScreen = '/profile/interest-screen';
  static const String profileLanguagesScreen = '/profile/languages-screen';
  static const String profileRelationshipGoalScreen =
      '/profile/relationship-goal-screen';
  static const String profileReligionScreen = '/profile/religion-screen';
  static const String profileMoviePreferencesScreen =
      '/profile/movie-preferences-screen';
  static const String profileMusicPreferencesScreen =
      '/profile/music-preferences-screen';
  static const String profileBookPreferencesScreen =
      '/profile/book-preferences-screen';
  static const String profileTravelPreferencesScreen =
      '/profile/travel-preferences-screen';
  static const String profileBasicScreen = '/profile/basic-screen';
  static const String profileLifestyleScreen = '/profile/lifestyle-screen';

  // ============ ERROR & MAINTENANCE ============
  static const String errorScreen = '/error-screen';
  static const String maintenanceScreen = '/maintenance-screen';
  static const String noInternetScreen = '/no-internet-screen';

  // ============ COMMON SCREENS ============
  static const String webViewScreen = '/web-view-screen';
  static const String imageViewerScreen = '/image-viewer-screen';
  static const String bottomNavigationBar = '/bottomNavigationBar';
  static const String fwdDetailScreen = '/fwdDetailScreen';
  static const String profileDetailsScreen = '/profileDetailsScreen';
  static const String chatDetailScreen = '/chatDetailScreen';
  static const String youGotMatch = '/youGotMatch';
  static const String searchScreen = '/searchScreen';
  static const String profileSettingScreen = '/profileSettingScreen';
}
