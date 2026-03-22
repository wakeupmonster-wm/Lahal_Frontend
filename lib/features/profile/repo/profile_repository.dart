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

  Future<ApiResponse> updateProfileImage(File file) async {
    return await _apiService.multipartRequest(
      url: AppUrls.updateProfileImage,
      method: HttpMethod.patch,
      files: [file],
      fileFieldName: 'uploadImg',
      includeHeaders: true,
    );
  }
  //implement update profile api

  Future<ApiResponse> updateProfile(Map<String, dynamic> body) async {
    return await _apiService.sendRequest(
      url: AppUrls.updateProfile,
      method: HttpMethod.patch,
      body: body,
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

  Future<ApiResponse> logout() async {
    return await _apiService.sendRequest(
      url: AppUrls.logout,
      method: HttpMethod.post,
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
}
