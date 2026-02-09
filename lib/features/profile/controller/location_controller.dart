import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/location_model.dart';
import '../repo/location_repository.dart';

class LocationController extends GetxController {
  final LocationRepository _locationRepo = LocationRepository();

  final searchController = TextEditingController();
  final RxList<LocationModel> searchResults = <LocationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initial search or load recent locations if needed
    searchLocations("");
  }

  Future<void> searchLocations(String query) async {
    isLoading.value = true;
    try {
      final results = await _locationRepo.searchLocations(query);
      searchResults.assignAll(results);
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void useCurrentLocation() {
    // Logic to get current location using geolocator or similar
    // For now, we'll just mock it or show a toast
    Get.snackbar("Location", "Using current location...");
  }

  void selectLocation(LocationModel location) {
    // Logic to save selected location and pop back
    Get.back(result: location);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
