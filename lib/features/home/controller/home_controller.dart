import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  final RxList<RestaurantModel> bestRestaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLocationLoading = false.obs;
  final RxString errorMessage = "".obs;
  final RxString currentAddress = "Melbourne, Victoria (VIC)".obs;

  // --- Filter State ---
  final RxDouble distanceRange = 200.0.obs;
  final RxInt rating = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getBestRestaurants();
    checkAndFetchLocation();
  }

  Future<void> checkAndFetchLocation() async {
    try {
      isLocationLoading.value = true;
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLocationLoading.value = false;
        return;
      }

      // Check for permissions using permission_handler
      var status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          // context.pop();
          isLocationLoading.value = false;
          return;
        }
      }

      if (status.isPermanentlyDenied) {
        // context.pop();
        isLocationLoading.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.subAdministrativeArea ?? "";
        String state = place.administrativeArea ?? "";
        String country = place.isoCountryCode ?? "";

        if (city.isNotEmpty && state.isNotEmpty) {
          currentAddress.value = "$city, $state ($country)";
        } else if (city.isNotEmpty) {
          currentAddress.value = "$city ($country)";
        }
      }
    } catch (e) {
      print("Error fetching location: $e");
    } finally {
      isLocationLoading.value = false;
    }
  }

  void updateDistanceRange(double value) {
    distanceRange.value = value;
  }

  void updateRating(int value) {
    rating.value = value;
  }

  void clearFilters() {
    distanceRange.value = 200.0;
    rating.value = 0;
  }

  void applyFilters() {
    // Logic to apply filters and fetch data
    getBestRestaurants();
  }

  Future<void> getBestRestaurants() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      final result = await _repository.fetchBestRestaurants();
      bestRestaurants.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
