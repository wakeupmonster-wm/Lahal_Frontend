import 'dart:io';
import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class ProfileRepository {
  final NetworkApiServices _apiService = NetworkApiServices();

  Future<ApiResponse> getProfile() async {
    return await _apiService.sendRequest(
      url: AppUrls.getProfile,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<ApiResponse> getFavoriteRestaurants({
    required double lat,
    required double lng,
  }) async {
    final uri = AppUrls.getAllFavourites.replace(
      queryParameters: {'lat': lat.toString(), 'lng': lng.toString()},
    );
    return await _apiService.sendRequest(
      url: uri,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<ApiResponse> updateProfile({
    required Map<String, String> fields,
    File? image,
  }) async {
    return await _apiService.multipartRequest(
      url: AppUrls.updateProfile,
      method: HttpMethod.patch,
      fields: fields,
      files: image != null ? [image] : [],
      fileFieldName: 'uploadImg',
      includeHeaders: true,
    );
  }

  Future<ApiResponse> getFaqs() async {
    return await _apiService.sendRequest(
      url: AppUrls.faqs,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<ApiResponse> getNotificationPreferences() async {
    return await _apiService.sendRequest(
      url: AppUrls.notificationPreferences,
      method: HttpMethod.get,
      includeHeaders: true,
    );
  }

  Future<ApiResponse> updateNotificationPreferences(
    Map<String, dynamic> body,
  ) async {
    return await _apiService.sendRequest(
      url: AppUrls.notificationPreferences,
      method: HttpMethod.post,
      body: body,
      includeHeaders: true,
    );
  }

  Future<ApiResponse> logout({
    required String refreshToken,
    required String deviceToken,
  }) async {
    return await _apiService.sendRequest(
      url: AppUrls.logout,
      method: HttpMethod.post,
      body: {
        'refreshToken': refreshToken,
        //  'deviceToken': deviceToken
      },
      includeHeaders: true,
    );
  }

  Future<ApiResponse> deleteAccount() async {
    return await _apiService.sendRequest(
      url: AppUrls.deleteAccount,
      method: HttpMethod.delete,
      includeHeaders: true,
    );
  }

  // Fetch Terms and Conditions
  Future<ApiResponse> getTermsAndConditions() async {
    return await _apiService.sendRequest(
      url: AppUrls.termsAndConditions,
      method: HttpMethod.get,
      includeHeaders: false,
    );
  }

  // Fetch Privacy Policy
  Future<ApiResponse> getPrivacyPolicy() async {
    return await _apiService.sendRequest(
      url: AppUrls.privacyPolicy,
      method: HttpMethod.get,
      includeHeaders: false,
    );
  }
}
