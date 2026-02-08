class AppUrls {
  // ---------------------------- BASE URL--------------------------

  static const String _baseUrl = "";

  static Uri setUrls(String uri) {
    return Uri.parse("$_baseUrl$uri");
  }

  static String setBaseUrl(String uri) {
    return "$_baseUrl$uri";
  }

  //  AUTH
  static Uri signIn = setUrls("/api/login");
  static Uri verifyOtp = setUrls("/api/verify-otp");
  static Uri resendOtp = setUrls("/api/resend-otp");

  // Home
  static Uri home = setUrls("/api/home");
  static Uri notifications = setUrls("/api/notifications");
  static Uri updateProfile = setUrls("/api/update-profile");
  static Uri getProfile = setUrls("/api/get-profile");
  static Uri faqs = setUrls("/api/faqs");
  static Uri notificationPreferences = setUrls("/api/notification-preferences");
  static Uri favorites = setUrls("/api/favorites");
  static Uri logout = setUrls("/api/logout");
}
