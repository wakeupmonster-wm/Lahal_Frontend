import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:lahal_application/features/home/controller/location_controller.dart'
    as global;
import 'package:lahal_application/features/profile/services/location_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import '../model/location_model.dart';

class ChangeLocationController extends GetxController {
  final LocationRepository _locationRepo = LocationRepository();
  final globalController = Get.find<global.LocationController>();

  final searchController = TextEditingController();
  final RxList<LocationModel> searchResults = <LocationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaveEnabled = false.obs;
  final RxBool showClearButton = false.obs;
  final RxBool isSaving = false.obs; // Loader for button
  String initialLocation = '';

  @override
  void onInit() {
    super.onInit();
    final address = globalController.currentAddress.value;
    if (address.isNotEmpty && address != 'Select your location') {
      searchController.text = address;
      initialLocation = address;
      showClearButton.value = true;
    }
  }

  void onSearchTextChanged(String value) {
    showClearButton.value = value.isNotEmpty;
    isSaveEnabled.value = false; // Need to select from list or use current to be sure
    if (value.isNotEmpty) {
      searchLocations(value);
    } else {
      searchResults.clear();
      _checkIfChanged();
    }
  }

  void clearSearch() {
    searchController.clear();
    showClearButton.value = false;
    searchResults.clear();
    _checkIfChanged();
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
    // Check permission logic natively
    final bool granted = await globalController.enableLocation(context);
    if (granted) {
      final address = globalController.currentAddress.value;
      if (address.isNotEmpty && address != 'Select your location') {
        searchController.text = address;
        searchResults.clear();
        showClearButton.value = true;
        _checkIfChanged();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  void selectLocation(LocationModel location) {
    // Use the title (or full description) of the place
    searchController.text = location.subtitle.isNotEmpty 
        ? '${location.title}, ${location.subtitle}' 
        : location.title;
    searchResults.clear();
    showClearButton.value = true;
    _checkIfChanged();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _checkIfChanged() {
    final currentText = searchController.text.trim();
    if (currentText.isNotEmpty && currentText != initialLocation) {
      isSaveEnabled.value = true;
    } else {
      isSaveEnabled.value = false;
    }
  }

  Future<void> saveLocation() async {
    if (!isSaveEnabled.value) return;

    isSaving.value = true;
    try {
      String address = searchController.text.trim();
      double lat = 0.0;
      double lng = 0.0;

      // Check if it's the current GPS location
      if (address == globalController.currentAddress.value && globalController.latitude.value != 0.0) {
        lat = globalController.latitude.value;
        lng = globalController.longitude.value;
      } else {
        // Find coordinates from geocoding
        try {
          List<geocoding.Location> locs = await geocoding.locationFromAddress(address);
          if (locs.isNotEmpty) {
            lat = locs.first.latitude;
            lng = locs.first.longitude;
          }
        } catch (_) {
          AppSnackBar.showToast(message: "Could not find coordinates for this address.");
          return;
        }
      }

      bool success = await globalController.saveCustomLocation(address, lat, lng);
      if (success) {
        Get.back();
      }
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
