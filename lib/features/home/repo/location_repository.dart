import 'package:get/get.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/datasources/remote/network_api_service.dart';
import 'package:lahal_application/features/home/model/saved_location_data.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class LocationRepository {
  final NetworkApiServices _networkService = NetworkApiServices();

  /// Saves the user's location to the server in the background.
  /// Returns the parsed [SavedLocationData] on success, null on failure.
  Future<SavedLocationData?> saveLocation({
    required String address,
    required String city,
    required String state,
    required double lat,
    required double lng,
  }) async {
    final isLoading = false.obs;
    final errorMessage = ''.obs;
    SavedLocationData? result;

    // Backend reads params from the query string, not the request body.
    final uri = AppUrls.saveUserLocation.replace(
      queryParameters: {
        'address': address,
        'city': city,
        'state': state,
        'lat': lat.toString(),
        'lng': lng.toString(),
      },
    );

    AppLogger.i('LocationRepository', 'Saving location — $uri');

    await ApiCallHandler.call(
      apiCall: () => _networkService.sendRequest(
        url: uri,
        method: HttpMethod.post,
      ),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (response) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          result = SavedLocationData.fromJson(data);
          AppLogger.i('LocationRepository', 'Location saved: $result');
        }
      },
      onError: (e) {
        AppLogger.w('LocationRepository', 'Location save failed: ${e.message}');
      },
    );

    return result;
  }
}
