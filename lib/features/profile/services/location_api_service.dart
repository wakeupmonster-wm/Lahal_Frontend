import 'package:get/get.dart';
import 'package:lahal_application/data/datasources/remote/api_call_handler.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/features/profile/repo/search_location_repository.dart';
import 'package:lahal_application/features/home/repo/location_repository.dart'
    as home_repo;
import '../model/location_model.dart';

class LocationApiService extends GetxService {
  late final SearchLocationRepository _locationRepo;
  late final home_repo.LocationRepository _saveRepo;

  @override
  void onInit() {
    super.onInit();
    _locationRepo = Get.put(SearchLocationRepository());
    _saveRepo = Get.put(home_repo.LocationRepository());
  }

  void searchLocations({
    required String query,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<List<LocationModel>> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<List<LocationModel>>(
      apiCall: () => _locationRepo.searchLocations(query),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  void getPlaceDetails({
    required String placeId,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse<Map<String, dynamic>> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call<Map<String, dynamic>>(
      apiCall: () => _locationRepo.getPlaceDetails(placeId),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
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
    required Function(ApiResponse<dynamic> response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    // Note: home_repo.LocationRepository.saveLocation doesn't actually return an ApiResponse but a specific model.
    // However, it internally uses ApiCallHandler or network services.
    // Let's check how it's implemented. In home_repo, it uses ApiCallHandler internally.
    // So we don't need another ApiCallHandler.call here if the repo already has it.

    // BUT to keep the pattern consistent if possible:
    final result = await _saveRepo.saveLocation(
      address: address,
      city: city,
      state: state,
      lat: lat,
      lng: lng,
    );

    if (result != null) {
      onSuccess(ApiResponse(status: true, message: 'Success', data: result));
    } else {
      onError?.call(const NetworkException('Failed to save location'));
    }
  }
}
