import 'package:get/get.dart';
import 'package:lahal_application/features/home/services/home_api_service.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/model/restaurant_list_response.dart';

class HomeService extends GetxService {
  late final HomeApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<HomeApiService>();
  }

  void loadRestaurants({
    required int page,
    required int limit,
    RestaurantFilters? filter,
    String? search,
    double? lat,
    double? lng,
    double? distance,
    int? minRating,
    String? cuisine,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(List<RestaurantModel> restaurants, RestaurantMetadata metadata) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.fetchRestaurants(
      page: page,
      limit: limit,
      filter: filter,
      search: search,
      lat: lat,
      lng: lng,
      distance: distance,
      minRating: minRating,
      cuisine: cuisine,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        final data = response.data;
        if (data != null) {
          AppLogger.i('HomeService', 'Fetched ${data.restaurants.length} restaurants (page $page)');
          onSuccess(data.restaurants, data.metadata);
        } else {
          AppLogger.w('HomeService', 'Response data was null');
          onSuccess([], const RestaurantMetadata(page: 1, limit: 20, count: 0, distanceRange: ''));
        }
      },
      onError: (error) {
        AppLogger.e('HomeService', 'Failed to load restaurants', error);
        onError?.call(error);
      },
    );
  }

  void addFavorite({
    required String restaurantId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(String message) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.addFavorite(
      restaurantId: restaurantId,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        AppLogger.i('HomeService', 'Successfully added $restaurantId to favorites. Message: ${response.message}');
        onSuccess(response.message);
      },
      onError: (error) {
        AppLogger.e('HomeService', 'Failed to add $restaurantId to favorites', error);
        onError?.call(error);
      },
    );
  }

  void removeFavorite({
    required String restaurantId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(String message) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.removeFavorite(
      restaurantId: restaurantId,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        AppLogger.i('HomeService', 'Successfully removed $restaurantId from favorites. Message: ${response.message}');
        onSuccess(response.message);
      },

      onError: (error) {
        AppLogger.e('HomeService', 'Failed to remove $restaurantId from favorites', error);
        onError?.call(error);
      },
    );
  }
}
