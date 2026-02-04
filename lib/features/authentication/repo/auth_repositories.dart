import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class AuthRepositories {
  final NetworkApiServices _apiService = NetworkApiServices();

  //---------------------------------login repo--------------------------------
  Future<Map<String, dynamic>> signIn(Map<String, dynamic> body) async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.signIn,
      method: HttpMethod.post,
      body: body.cast<String, String>(),
      includeHeaders: false,
    );
  }

  //---------------------------------verify otp repo---------------------------
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> body) async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.verifyOtp,
      method: HttpMethod.post,
      body: body.cast<String, String>(),
      includeHeaders: false,
    );
  }

  //---------------------------------resend otp repo---------------------------
  Future<Map<String, dynamic>> resendOtp(Map<String, dynamic> body) async {
    return await _apiService.sendHttpRequest(
      url: AppUrls.resendOtp,
      method: HttpMethod.post,
      body: body.cast<String, String>(),
      includeHeaders: false,
    );
  }
}
