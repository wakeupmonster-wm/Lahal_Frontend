import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/data/services/location_service.dart';
import 'package:lahal_application/features/home/model/saved_location_data.dart';
import 'package:lahal_application/features/home/repo/location_repository.dart';
import 'package:lahal_application/utils/components/location/location_permission_sheet.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/data/datasources/local/storage_utility.dart';

class LocationController extends GetxController {
  final LocationRepository _locationRepository = LocationRepository();

  final isLocationLoading = true.obs;
  final currentAddress = 'Select your location'.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  /// True once location has been successfully obtained at least once.
  final hasLocation = false.obs;

  /// True if the user declined the location permission (soft or hard).
  final locationDenied = false.obs;

  /// The parsed response data from the location-save API.
  final Rx<SavedLocationData?> savedLocation = Rx<SavedLocationData?>(null);

  /// Runs when controller is ready
  @override
  void onReady() async {
    super.onReady();

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      /// If already allowed → fetch silently
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await fetchLocation();
      } else {
        isLocationLoading.value = false;
      }
    } catch (e) {
      log(e.toString());
      isLocationLoading.value = false;
    }
  }

  /// Check if popup should be shown (only first time)
  bool shouldShowLocationPopup() {
    return !(AppLocalStorage.instance().readData<bool>(
          'has_shown_location_popup',
        ) ??
        false);
  }

  /// Save popup state
  Future<void> markLocationPopupAsShown() async {
    await AppLocalStorage.instance().writeData(
      'has_shown_location_popup',
      true,
    );
  }

  /// Enable location from popup or from the NoLocationWidget button.
  /// Returns true if location was successfully fetched.
  Future<bool> enableLocation(BuildContext context) async {
    try {
      isLocationLoading.value = true;
      locationDenied.value = false;

      LocationPermission permission = await Geolocator.checkPermission();

      /// Ask permission if not already granted
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      /// Permanently denied → open settings
      if (permission == LocationPermission.deniedForever) {
        locationDenied.value = true;
        await LocationService.openAppSettings();
        return false;
      }

      /// Soft-denied → inform user
      if (permission == LocationPermission.denied) {
        locationDenied.value = true;
        AppSnackBar.showToast(message: "Location permission denied");
        return false;
      }

      /// Check GPS service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.showToast(message: "Please enable location");
        return false;
      }

      /// Fetch location
      await fetchLocation();
      return hasLocation.value;
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      isLocationLoading.value = false;
    }
  }

  /// Fetch device location and save it to the server in the background.
  Future<void> fetchLocation() async {
    try {
      isLocationLoading.value = true;

      final position = await LocationService.getCurrentPosition();

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      currentAddress.value = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      hasLocation.value = true;
      locationDenied.value = false;

      // Fire-and-forget: save location to server in the background.
      _saveLocationToServer(position.latitude, position.longitude);
    } catch (e) {
      log(e.toString());
      AppSnackBar.showToast(message: "Unable to fetch location");
    } finally {
      isLocationLoading.value = false;
    }
  }

  /// Fire-and-forget location API call.
  void _saveLocationToServer(double lat, double lng) {
    LocationService.getAddressDetailsFromLatLng(lat, lng).then((details) async {
      final result = await _locationRepository.saveLocation(
        address: details['address'] ?? '',
        city: details['city'] ?? '',
        state: details['state'] ?? '',
        lat: lat,
        lng: lng,
      );
      if (result != null) {
        savedLocation.value = result;
      }
    });
  }

  /// Manual search navigation
  void openManualSearch(BuildContext context) {
    context.push(AppRoutes.changeLocationScreen);
  }

  /// Show permission sheet
  void showLocationSheet(BuildContext context) {
    LocationPermissionSheet.show(
      context,
      onEnable: () async {
        await markLocationPopupAsShown();
        await enableLocation(context);
      },
      onManualSearch: () async {
        await markLocationPopupAsShown();
        openManualSearch(context);
      },
    );
  }
}
