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
  static Uri testSendOtp = setUrls("/api/v1/auth/test/send-otp"); // testSendOTP
  static Uri sendOtp = setUrls("/api/v1/auth/send-phone-otp");
  static Uri verifyOtp = setUrls("/api/v1/auth/verify-phone-otp");
  static Uri resendOtp = setUrls(
    "/api/v1/auth/test/send-otp",
  ); // need to change with real one
  static Uri refreshToken = setUrls("/api/v1/auth/refresh");

  // Home
  static Uri saveUserLocation = setUrls("/api/v1/user/location-save");
  static String getRestaurants = setBaseUrl(
    "/api/v1/restaurants/nearbyrestaurants",
  );
  static String getRestaurantById = setBaseUrl("/api/v1/restaurants");
  static Uri addFavouriteRestuarant = setUrls("/api/v1/user/add-favourites");
  static Uri removeFavouriteRestuarant = setUrls(
    "/api/v1/user/update-favourites",
  );

  static Uri reportError = setUrls("/api/v1/reports/restaurant");

  static Uri home = setUrls("/api/home");
  static Uri notifications = setUrls("/api/notifications");

  static Uri faqs = setUrls("/api/v1/cms/faq"); //implemented
  static Uri notificationPreferences = setUrls("/api/notification-preferences");
  static Uri nearbyRestaurants = setUrls(
    "/api/v1/restaurants/nearbyrestaurants",
  );
  static Uri logout = setUrls("/api/v1/auth/logout"); //implemented

  //ashu add resturent implemented
  static Uri submitRestaurantRequest = setUrls(
    "/api/v1/restaurants/addrestaurant-by-req",
  );
  static Uri addRestaurantRequest = setUrls("/api/v1/restaurants/add-request");
  static Uri updateProfile = setUrls("/api/v1/user/update-profile");
  static Uri getProfile = setUrls("/api/v1/user");
  //ashu profile
  static Uri getAllFavourites = setUrls("/api/v1/user/get-all-favourites");
  static Uri deleteAccount = setUrls("/api/v1/user/delete-account");
  // cms
  static Uri termsAndConditions = setUrls("/api/v1/cms/terms-condition");
  static Uri privacyPolicy = setUrls("/api/v1/cms/privacy-policy");

  // Third-Party
  static const String aladhanBaseUrl = "https://api.aladhan.com/v1";
}
