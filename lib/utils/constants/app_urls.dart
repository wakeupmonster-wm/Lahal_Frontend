class AppUrls {
  static const String _baseUrl = "https://apibackend.trimify.com.au";

  static Uri setUrls(String uri) {
    return Uri.parse("$_baseUrl$uri");
  }

  static String setBaseUrl(String uri) {
    return "$_baseUrl$uri";
  }

  // -- Auth--- lalah---
  static Uri signUp = setUrls("/api/signup");
}
