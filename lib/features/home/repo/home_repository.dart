import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/features/home/model/restaurant_list_response.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class HomeRepository {
  final NetworkApiServices _network = NetworkApiServices();

  /// Fetches restaurants with pagination, optional filter, search, location,
  /// distance radius, minimum rating, and cuisine type.
  Future<ApiResponse<RestaurantListResponse>> fetchRestaurants({
    required int page,
    required int limit,
    RestaurantFilters? filter,
    String? search,
    double? lat,
    double? lng,
    double? distance,   // search radius in km (e.g. 5 = 5km)
    int? minRating,     // e.g. 4 → only 4★ and above
    String? cuisine,    // e.g. "Italian,Indian"
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // Filter param (top_rated, open_now, certified, top_reviewed)
    final filterValue = filter?.filterValue;
    if (filterValue != null) {
      queryParams['filter'] = filterValue;
    }

    // Search
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    // Lat/Lng for Near You
    if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
      queryParams['lat'] = lat.toStringAsFixed(6);
      queryParams['lng'] = lng.toStringAsFixed(6);
    }

    // Distance radius in km (sent as integer per API convention)
    if (distance != null && distance > 0) {
      queryParams['distance'] = distance.toInt().toString();
    }

    // Minimum star rating
    if (minRating != null && minRating > 0) {
      queryParams['minRating'] = minRating.toString();
    }

    // Cuisine (comma-separated for multi-select)
    if (cuisine != null && cuisine.trim().isNotEmpty) {
      queryParams['cuisine'] = cuisine.trim();
    }

    final uri = Uri.parse(AppUrls.getRestaurants).replace(
      queryParameters: queryParams,
    );

    final rawResponse = await _network.sendRequest<dynamic>(
      url: uri,
      method: HttpMethod.get,
    );

    final List<RestaurantModel> restaurants = [];
    if (rawResponse.data is List) {
      for (final item in rawResponse.data as List) {
        if (item is Map<String, dynamic>) {
          restaurants.add(RestaurantModel.fromJson(item));
        }
      }
    }

    final metadata = RestaurantMetadata(
      page: page,
      limit: limit,
      count: restaurants.length,
      distanceRange: distance != null ? '${distance.toInt()}km' : '',
    );

    return ApiResponse<RestaurantListResponse>(
      status: rawResponse.status,
      message: rawResponse.message,
      data: RestaurantListResponse(
        metadata: metadata,
        restaurants: restaurants,
      ),
    );
  }

  Future<ApiResponse<dynamic>> addFavoriteRestaurant(String restaurantId) async {
    final rawResponse = await _network.sendRequest<dynamic>(
      url: AppUrls.addFavouriteRestuarant,
      method: HttpMethod.post,
      body: {"restaurantId": restaurantId},
    );

    return ApiResponse<dynamic>(
      status: rawResponse.status,
      message: rawResponse.message,
      data: rawResponse.data,
    );
  }

  Future<ApiResponse<dynamic>> removeFavoriteRestaurant(String restaurantId) async {
    final rawResponse = await _network.sendRequest<dynamic>(
      url: AppUrls.removeFavouriteRestuarant,
      method: HttpMethod.patch,
      body: {"restaurantId": restaurantId},
    );

    return ApiResponse<dynamic>(
      status: rawResponse.status,
      message: rawResponse.message,
      data: rawResponse.data,
    );
  }
}
