import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart'
    as global;
import '../model/location_model.dart';
import '../repo/location_repository.dart';

class ChangeLocationController extends GetxController {
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

  void useCurrentLocation(BuildContext context) {
    final globalController = Get.find<global.LocationController>();
    globalController.fetchLocation(openSettings: true).then((_) {
      // Get.back(); // Return to previous screen after fetching
      // context.pop();
    });
  }

  void selectLocation(LocationModel location) {
    // Logic to save selected location and pop back
    final globalController = Get.find<global.LocationController>();
    globalController.currentAddress.value = location.title;

    Get.back(result: location);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
