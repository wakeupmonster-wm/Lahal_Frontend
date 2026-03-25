import 'dart:io';
import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class AddRestaurantRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> addRestaurantRequest({
    required Map<String, String> fields,
    required Map<String, List<File>> multipartFiles,
  }) async {
    return await _network.multipartRequest(
      url: AppUrls.addRestaurantRequest,
      method: HttpMethod.post,
      fields: fields,
      multiFiles: multipartFiles,
      includeHeaders: true,
    );
  }
}
