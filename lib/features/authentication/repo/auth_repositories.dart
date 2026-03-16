import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class AuthRepositories {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> sendOtp(Map<String, dynamic> body) async {
    return await _network.sendRequest(
      url: AppUrls.testSendOtp, // Using test for now as requested
      method: HttpMethod.post,
      body: body,
      includeHeaders: false,
    );
  }

  Future<ApiResponse> verifyOtp(Map<String, dynamic> body) async {
    return await _network.sendRequest(
      url: AppUrls.verifyOtp,
      method: HttpMethod.post,
      body: body,
      includeHeaders: false,
    );
  }

  Future<ApiResponse> resendOtp(Map<String, dynamic> body) async {
    return await _network.sendRequest(
      url: AppUrls.resendOtp,
      method: HttpMethod.post,
      body: body,
      includeHeaders: false,
    );
  }
}
