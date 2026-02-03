import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/authentication/view/screen/sign_in_screen.dart';
import 'package:lahal_application/features/splash/view/screen/splash_screen.dart';
import 'package:lahal_application/features/authentication/view/screen/auth_entry_screen.dart';
import 'package:lahal_application/features/authentication/view/screen/otp_verification_screen.dart';
import 'package:lahal_application/features/authentication/view/screen/welcome_screen.dart';
import 'package:lahal_application/features/help_and_support/view/contact_support_screen.dart';
import 'package:lahal_application/features/help_and_support/view/f&q_screen.dart';
import 'package:lahal_application/main.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import '../../features/bottomNavigationBar/view/bottom_navigationbar.dart';
import '../../features/help_and_support/view/privacy_policy_screen.dart';
import '../../features/help_and_support/view/terms_and_condation_screen.dart';
import '../../features/help_and_support/view/help_and_support_Screen.dart';

part 'app_routes.dart';

class AppGoRouter {
  static GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      // ** Auth
      _createRoute('/', const SplashScreen()),
      _createRoute(AppRoutes.signInScreen, const SignInScreen()),
      _createRoute(
        AppRoutes.otpVerify,
        const OtpVerificationScreen(mode: AuthEntryMode.phone, data: ""),
      ),
      _createRoute(AppRoutes.bottomNavigationBar, BottomNavigationbar()),
      // _createRoute(AppRoutes.fwdDetailScreen, FwdDetailScreen()),
      // _createRoute(AppRoutes.profileDetailsScreen, ProfileDetailsScreen()),
      // _createRoute(AppRoutes.chatDetailScreen, ChatDetailScreen()),
      // _createRoute(AppRoutes.youGotMatch, YouGotMatchScreen()),
      // _createRoute(AppRoutes.noInternetScreen, NotificationScreen()),
      // _createRoute(AppRoutes.searchScreen, SearchBenefitsScreen()),
      // _createRoute(AppRoutes.profileSettingScreen, SettingsScreen()),
      // _createRoute(AppRoutes.notificationSettingScreen, NotificationSettingScreen()),
      // _createRoute(AppRoutes.accountSecurityScreen, AccountSecurityScreen()),
      // _createRoute(AppRoutes.subscriptionScrees, SubscriptionScreen()),
      // _createRoute(AppRoutes.dataAnalyticsScreen, DataAnalyticsScreen()),
      // _createRoute(AppRoutes.profilePrivacyScreen, ProfilePrivacyScreen()),
      // _createRoute(AppRoutes.visibilityScreen, VisibilityScreen()),
      // _createRoute(AppRoutes.usernameScreen, UsernameScreen()),
      // _createRoute(AppRoutes.blockedUsersScreen, BlockedUsersScreen()),
      // _createRoute(AppRoutes.blockContactsScreen, BlockContactsScreen()),
      // _createRoute(AppRoutes.helpAndSupportScreen, HelpSupportScreen()),
      // _createRoute(AppRoutes.faqScreen, FaqScreen()),
      // _createRoute(AppRoutes.contactSupportScreen, ContactSupportScreen()),
      // _createRoute(AppRoutes.termsConditionsScreen, TermsConditionsScreen()),
      // _createRoute(
      //   AppRoutes.privacyPolicyScreenHelp,
      //   PrivacyPolicyScreenHelp(),
      // ),
      // _createRoute("/", const SignInScreen()),
      GoRoute(
        path: AppRoutes.authEntry,
        pageBuilder: (context, state) {
          final mode = state.extra as AuthEntryMode;
          return _buildTransitionPage(
            context,
            state,
            AuthEntryScreen(mode: mode),
          );
        },
      ),
      // GoRoute(
      //   path: AppRoutes.otpVerify,
      //   pageBuilder: (context, state) {
      //     final extra = state.extra as Map<String, dynamic>;
      //     final mode = extra['mode'] as AuthEntryMode;
      //     final data = extra['data'] as String?;
      //     return _buildTransitionPage(
      //       context,
      //       state,
      //       OtpVerificationScreen(mode: mode, data: data),
      //     );
      //   },
      // ),
      // _createRoute("/s", const EnterNameScreen()),
      // _createRoute(AppRoutes.profileDob, const DobScreen()),
      // _createRoute(AppRoutes.profileYourIdentity, const YourIdentityScreen()),
      // _createRoute(AppRoutes.profileRelationshipGoal, const RelationshipGoalScreen()),
      // _createRoute(AppRoutes.profileInterestedIn, const InterestedInScreen()),
      // _createRoute(AppRoutes.profileAgeRange, const AgeRangeScreen()),
      // _createRoute(AppRoutes.profileDistancePref, const DistancePrefScreen()),
      // _createRoute(AppRoutes.profileInterests, InterestsScreen()),
      // _createRoute(AppRoutes.profileUploadPhotos, const UploadPhotosScreen()),
      // _createRoute(AppRoutes.profileSelfieVerify, const SelfieVerifyScreen()),
      // // _createRoute(AppRoutes.profileDocVerify, const IdVerificationScreen()),
      // _createRoute(AppRoutes.editProfileScreen, const EditProfileScreen()),
      // _createRoute(AppRoutes.profileInterestScreen, const ProfileInterestScreen()),

      // _createRoute(AppRoutes.profileLanguagesScreen, const ProfileLanguageScreen()),
      // // _createRoute(AppRoutes.profileRelationshipGoalScreen, const RelationshipGoalScreen()),
      // _createRoute(AppRoutes.profileReligionScreen, const ProfileReligionScreen()),
      // _createRoute(AppRoutes.profileMoviePreferencesScreen, const ProfileMoviePreferencesScreen()),
      // _createRoute(AppRoutes.profileMusicPreferencesScreen, const ProfileMusicPreferencesScreen()),
      // _createRoute(AppRoutes.profileBookPreferencesScreen, const ProfileBooksPreferenceScreen()),
      // _createRoute(AppRoutes.profileTravelPreferencesScreen, const ProfileTravelPreferencesScreen()),
      // _createRoute(AppRoutes.profileBasicScreen, const ProfileBasicsScreen()),
      // _createRoute(AppRoutes.profileLifestyleScreen, const ProfileLifestyleScreen()),
    ],
  );

  /// Returns a [GoRoute] that navigates to the given [path] and shows
  /// the given [child] widget. The [child] is wrapped with a fade transition.
  static GoRoute _createRoute(String path, Widget child) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) =>
          _buildTransitionPage(context, state, child),
    );
  }

  /// Builds a [Page] with a fade transition.
  ///
  /// This is a simple [CustomTransitionPage] that fades in the given [child]
  /// widget over a default duration of 300 milliseconds.
  ///
  static Page _buildTransitionPage(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: false,
    );
  }
}
