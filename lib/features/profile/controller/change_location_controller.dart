import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart'
    as global;
import 'package:lahal_application/features/profile/services/location_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import '../model/location_model.dart';

class ChangeLocationController extends GetxController {
  late final LocationService _locationService;

  final searchController = TextEditingController();
  final RxList<LocationModel> searchResults = <LocationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Register dependencies properly
    if (!Get.isRegistered<LocationService>()) {
      Get.put(LocationService());
    }
    _locationService = Get.find<LocationService>();

    // Initial load
    searchLocations("");
  }

  void searchLocations(String query) {
    _locationService.searchLocations(
      query: query,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (locations) {
        searchResults.assignAll(locations);
      },
      onError: (error) {
        // Error message is handled by RxString in ApiCallHandler
      },
    );
  }

  void useCurrentLocation(BuildContext context) async {
    final globalController = Get.find<global.LocationController>();
    isLoading.value = true;
    try {
      await globalController.enableLocation(context);

      if (globalController.currentAddress.value.isNotEmpty &&
          globalController.currentAddress.value != 'Select your location') {
        // Sync search field for visual consistency
        searchController.text = globalController.currentAddress.value;

        AppSnackBar.showToast(message: "Location updated successfully");
        Get.back();
      }
    } catch (e) {
      AppSnackBar.showToast(message: "Failed to fetch current location");
    } finally {
      isLoading.value = false;
    }
  }

  void selectLocation(LocationModel location) async {
    if (location.placeId == null) return;

    _locationService.getPlaceDetails(
      placeId: location.placeId!,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (details) {
        _saveSelectedLocation(location, details);
      },
    );
  }

  void _saveSelectedLocation(
    LocationModel location,
    Map<String, dynamic> details,
  ) {
    _locationService.saveLocation(
      address: details['address'] ?? location.title,
      city: details['city'] ?? '',
      state: details['state'] ?? '',
      lat: details['lat'],
      lng: details['lng'],
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (result) {
        // Update Global State
        final globalController = Get.find<global.LocationController>();
        globalController.currentAddress.value = location.title;
        globalController.latitude.value = details['lat'];
        globalController.longitude.value = details['lng'];
        globalController.savedLocation.value = result;

        AppSnackBar.showToast(message: "Location saved successfully");
        Get.back(result: location);
      },
      onError: (error) {
        AppSnackBar.showToast(message: "Failed to save location");
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
