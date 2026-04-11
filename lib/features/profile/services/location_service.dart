import 'package:get/get.dart';
import 'package:lahal_application/features/profile/services/location_api_service.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';
import '../model/location_model.dart';

class LocationService extends GetxService {
  late final LocationApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.put(LocationApiService());
  }

  void searchLocations({
    required String query,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(List<LocationModel> locations) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.searchLocations(
      query: query,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        final data = response.data;
        if (data != null) {
          AppLogger.i('LocationService', 'Found ${data.length} suggestions');
          onSuccess(data);
        } else {
          onSuccess([]);
        }
      },
      onError: (error) {
        AppLogger.e('LocationService', 'Search failed', error);
        onError?.call(error);
      },
    );
  }

  void getPlaceDetails({
    required String placeId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(Map<String, dynamic> details) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.getPlaceDetails(
      placeId: placeId,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        final data = response.data;
        if (data != null) {
          onSuccess(data);
        }
      },
      onError: (error) {
        AppLogger.e('LocationService', 'Place details failed', error);
        onError?.call(error);
      },
    );
  }

  void saveLocation({
    required String address,
    required String city,
    required String state,
    required double lat,
    required double lng,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(dynamic result) onSuccess,
    Function(dynamic error)? onError,
  }) {
    _apiService.saveLocation(
      address: address,
      city: city,
      state: state,
      lat: lat,
      lng: lng,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        onSuccess(response.data);
      },
      onError: (error) {
        AppLogger.e('LocationService', 'Location save failed', error);
        onError?.call(error);
      },
    );
  }
}
