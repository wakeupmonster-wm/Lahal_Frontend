import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lahal_application/data/datasources/local/user_prefrence.dart';
import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class ApiCallHandler {
  static bool _isRefreshing = false;

  /// Call API with connectivity check, loading state, and auto token refresh
  static Future<void> call<T>({
    required Future<ApiResponse<T>> Function() apiCall,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<T> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    // 1. Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool connected = !connectivityResult.contains(
      ConnectivityResult.none,
    );

    if (!connected) {
      const error = NetworkException();
      errorMessage.value = error.message;
      onError?.call(error);
      return;
    }

    // 2. Execute with loading state
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiCall();
      if (response.isSuccess) {
        onSuccess(response);
      } else {
        final error = ApiStatusFalseException(response.message);
        errorMessage.value = error.message;
        onError?.call(error);
      }
    } on UnauthorizedException catch (_) {
      // 3. Attempt token refresh on 401
      final refreshed = await _attemptTokenRefresh();
      if (refreshed) {
        // Retry original call once
        try {
          final retryResponse = await apiCall();
          if (retryResponse.isSuccess) {
            onSuccess(retryResponse);
          } else {
            final error = ApiStatusFalseException(retryResponse.message);
            errorMessage.value = error.message;
            onError?.call(error);
          }
        } on AppException catch (retryError) {
          errorMessage.value = retryError.message;
          onError?.call(retryError);
        }
      } else {
        // Refresh failed — force logout
        const error = TokenRefreshException();
        errorMessage.value = error.message;
        onError?.call(error);
        await _forceLogout();
      }
    } on AppException catch (e) {
      errorMessage.value = e.message;
      onError?.call(e);
    } catch (e, stack) {
      AppLogger.e('ApiCallHandler', 'Unexpected error', e, stack);
      const error = NetworkException('An unexpected error occurred');
      errorMessage.value = error.message;
      onError?.call(error);
    } finally {
      isLoading.value = false;
    }
  }

  static Future<bool> _attemptTokenRefresh() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      AppLogger.i('ApiCallHandler', 'Attempting token refresh');
      final prefs = UserPreferences();
      final refreshToken = await prefs.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.w('ApiCallHandler', 'Refresh token missing — cannot refresh');
        return false;
      }

      final networkService = NetworkApiServices();
      final response = await networkService.sendRequest(
        url: AppUrls.refreshToken,
        method: HttpMethod.post,
        body: {
          'refreshToken': refreshToken,
        },
        useRefreshToken: true,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final authData = data['auth'] as Map<String, dynamic>?;

        if (authData != null && authData['accessToken'] != null) {
          final prefs = UserPreferences();
          await prefs.setToken(authData['accessToken']);
          if (authData['refreshToken'] != null) {
            await prefs.setRefreshToken(authData['refreshToken']);
          }
          AppLogger.i('ApiCallHandler', 'Token refresh successful');
          return true;
        }
      }
      return false;
    } catch (e) {
      AppLogger.e('ApiCallHandler', 'Token refresh failed', e);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  static Future<void> _forceLogout() async {
    AppLogger.w('ApiCallHandler', 'Forcing logout — token refresh failed');
    final prefs = UserPreferences();
    await prefs.removeToken();
    // Navigation will be handled by the caller's onError callback
  }
}
