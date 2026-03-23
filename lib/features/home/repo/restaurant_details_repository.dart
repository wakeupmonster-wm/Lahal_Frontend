import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/features/home/model/restaurant_details_model.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class RestaurantDetailsRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse<RestaurantDetailsModel>> getRestaurantDetails(String restaurantId) async {
    final uri = Uri.parse('${AppUrls.getRestaurantById}/$restaurantId');

    final rawResponse = await _network.sendRequest<dynamic>(
      url: uri,
      method: HttpMethod.get,
    );

    // Parse the inner "data" which is exactly what the model expects
    final model = RestaurantDetailsModel.fromJson(rawResponse.data as Map<String, dynamic>);

    return ApiResponse<RestaurantDetailsModel>(
      status: rawResponse.status,
      message: rawResponse.message,
      data: model,
    );
  }
}
