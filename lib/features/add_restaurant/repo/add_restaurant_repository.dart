import 'dart:io';
import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class AddRestaurantRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> submitRestaurantRequest(Map<String, dynamic> body) async {
    return await _network.sendRequest(
      url: AppUrls.submitRestaurantRequest,
      method: HttpMethod.post,
      body: body,
      includeHeaders: true,
    );
  }

  Future<ApiResponse> uploadFoodImages(List<File> images) async {
    return await _network.multipartRequest(
      url: AppUrls.uploadFoodImages,
      method: HttpMethod.post,
      files: images,
      fileFieldName: 'foodsImgs',
      includeHeaders: true,
    );
  }
}
