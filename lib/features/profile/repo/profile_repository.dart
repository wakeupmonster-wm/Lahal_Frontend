import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class ProfileRepository {
  final NetworkApiServices _apiService = NetworkApiServices();

  Future<Map<String, dynamic>> getProfile() async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.getProfile,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.updateProfile,
      method: HttpMethod.post,
      body: body.cast<String, String>(),
      includeHeaders: true,
    );
  }

  Future<Map<String, dynamic>> getFaqs() async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.faqs,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<Map<String, dynamic>> getNotificationPreferences() async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.notificationPreferences,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> body,
  ) async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.notificationPreferences,
      method: HttpMethod.post,
      body: body.cast<String, String>(),
      includeHeaders: true,
    );
  }

  Future<Map<String, dynamic>> logout() async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.logout,
      method: HttpMethod.post,
      includeHeaders: true,
    );
  }
}
