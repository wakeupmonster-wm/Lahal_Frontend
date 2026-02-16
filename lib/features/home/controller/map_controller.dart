import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';

class MapController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  // Map State
  Completer<GoogleMapController> mapController = Completer();
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final Rx<RestaurantModel?> selectedRestaurant = Rx<RestaurantModel?>(null);

  // Loading State
  final RxBool isLoading = true.obs;

  // Filter State
  final RxString selectedFilter = "Near you".obs;

  // Carousel Controller
  late PageController pageController;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-37.8136, 144.9631), // Melbourne
    zoom: 13,
  );

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.85);
    fetchRestaurants();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      // Fetching all restaurants to show on map
      final results = await _repository.fetchBestRestaurants();
      restaurants.assignAll(results);
      _createMarkers();

      if (restaurants.isNotEmpty) {
        selectedRestaurant.value = restaurants.first;
      }
    } catch (e) {
      print("Error fetching restaurants for map: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _createMarkers() {
    markers.clear();
    for (var restaurant in restaurants) {
      markers.add(
        Marker(
          markerId: MarkerId(restaurant.id),
          position: LatLng(restaurant.latitude, restaurant.longitude),
          infoWindow: InfoWindow(
            title: restaurant.name,
            snippet: restaurant.address,
          ),
          onTap: () {
            _onMarkerTapped(restaurant);
          },
          // TODO: Custom marker icon implementation if needed
        ),
      );
    }
  }

  void _onMarkerTapped(RestaurantModel restaurant) {
    selectedRestaurant.value = restaurant;
    int index = restaurants.indexOf(restaurant);
    if (index != -1) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    if (index >= 0 && index < restaurants.length) {
      final restaurant = restaurants[index];
      selectedRestaurant.value = restaurant;
      _animateCamera(restaurant.latitude, restaurant.longitude);
    }
  }

  Future<void> _animateCamera(double lat, double lng) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    // Implement filter logic here if needed
    // For now just updating UI selection
  }
}
