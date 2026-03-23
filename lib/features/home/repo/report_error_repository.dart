import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class ReportErrorRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<ApiResponse<dynamic>> submitReport({
    required String restaurantId,
    required List<String> reasons,
    required String message,
  }) async {
    final Map<String, dynamic> body = {
      "restaurantId": restaurantId,
      "reasons": reasons,
      "message": message,
    };
    return await _apiServices.sendRequest<dynamic>(
      url: AppUrls.reportError,
      method: HttpMethod.post,
      body: body,
      useRefreshToken: true,
    );
  }
}
