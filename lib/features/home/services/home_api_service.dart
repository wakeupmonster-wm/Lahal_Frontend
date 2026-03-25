import 'package:get/get.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/features/home/model/restaurant_list_response.dart';
import 'package:lahal_application/utils/constants/enum.dart';

class HomeApiService extends GetxService {
  late final HomeRepository _homeRepo;

  @override
  void onInit() {
    super.onInit();
    _homeRepo = Get.find<HomeRepository>();
  }

  void fetchRestaurants({
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
    required Function(ApiResponse<RestaurantListResponse> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<RestaurantListResponse>(
      apiCall: () => _homeRepo.fetchRestaurants(
        page: page,
        limit: limit,
        filter: filter,
        search: search,
        lat: lat,
        lng: lng,
        distance: distance,
        minRating: minRating,
        cuisine: cuisine,
      ),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  void addFavorite({
    required String restaurantId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<dynamic> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<dynamic>(
      apiCall: () => _homeRepo.addFavoriteRestaurant(restaurantId),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  void removeFavorite({
    required String restaurantId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<dynamic> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<dynamic>(
      apiCall: () => _homeRepo.removeFavoriteRestaurant(restaurantId),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
