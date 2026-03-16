class AppUrls {
  // ---------------------------- BASE URL--------------------------

  static const String _baseUrl = "https://api.lalah.au";

  static Uri setUrls(String uri) {
    return Uri.parse("$_baseUrl$uri");
  }

  static String setBaseUrl(String uri) {
    return "$_baseUrl$uri";
  }

  //  AUTH
  static Uri testSendOtp = setUrls("/api/v1/auth/test/send-otp");   // testSendOTP
  static Uri sendOtp = setUrls("/api/v1/auth/send-phone-otp");  
  static Uri verifyOtp = setUrls("/api/v1/auth/verify-phone-otp");
  static Uri resendOtp = setUrls("/api/v1/auth/test/send-otp");  // need to change with real one
  static Uri refreshToken = setUrls("/api/v1/auth/refresh");



  // Home
  static Uri saveUserLocation = setUrls("/api/v1/user/location-save"); // uses query-params

  static Uri home = setUrls("/api/home");
  static Uri notifications = setUrls("/api/notifications");
  static Uri updateProfile = setUrls("/api/update-profile");
  static Uri getProfile = setUrls("/api/get-profile");
  static Uri faqs = setUrls("/api/faqs");
  static Uri notificationPreferences = setUrls("/api/notification-preferences");
  static Uri favorites = setUrls("/api/favorites");
  static Uri logout = setUrls("/api/logout");

  // Third-Party
  static const String aladhanBaseUrl = "https://api.aladhan.com/v1";
}
