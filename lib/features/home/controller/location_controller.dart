import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'package:lahal_application/data/services/location_service.dart';
import 'package:lahal_application/utils/components/location/location_permission_sheet.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/data/datasources/local/storage_utility.dart';

class LocationController extends GetxController {
  final isLocationLoading = false.obs;

  final currentAddress = 'Select your location'.obs;

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

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
      }
    } catch (e) {
      log(e.toString());
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

  /// Enable location from popup
  Future<void> enableLocation(BuildContext context) async {
    try {
      isLocationLoading.value = true;

      LocationPermission permission = await Geolocator.checkPermission();

      /// Ask permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      /// If denied again
      if (permission == LocationPermission.denied) {
        // AppSnackBar.showToast(message: "Location permission denied");
        Fluttertoast.showToast(
          msg: "Location permission denied",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      /// If permanently denied → open settings
      if (permission == LocationPermission.deniedForever) {
        await LocationService.openAppSettings();
        return;
      }

      /// Check GPS service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // AppSnackBar.showToast(message: "Please enable GPS");
        Fluttertoast.showToast(
          msg: "Please enable GPS",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      /// Fetch location
      await fetchLocation();
    } catch (e) {
      log(e.toString());
    } finally {
      isLocationLoading.value = false;
    }
  }

  /// Fetch device location
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
    } catch (e) {
      log(e.toString());
      // AppSnackBar.showToast(message: "Unable to fetch location");
      Fluttertoast.showToast(
        msg: "Unable to fetch location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      isLocationLoading.value = false;
    }
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
