import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart';
import 'package:lahal_application/features/home/model/restaurant_model.dart';
import 'package:lahal_application/features/home/repo/home_repository.dart';
import 'package:lahal_application/features/home/services/home_api_service.dart';
import 'package:lahal_application/features/home/model/restaurant_list_response.dart';
import 'package:lahal_application/features/home/services/home_service.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class MapController extends GetxController {
  // ---- Map Native State ----
  Completer<GoogleMapController> mapController = Completer();

  /// Full marker set rendered on the map. Uses RxSet so GoogleMap rebuilds reactively.
  final RxSet<Marker> markers = <Marker>{}.obs;

  // ---- Restaurant State ----
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final Rx<RestaurantModel?> selectedRestaurant = Rx<RestaurantModel?>(null);

  /// Track which markerId is currently highlighted so we only rebuild 2 markers on change.
  String? _selectedMarkerId;

  // ---- Loading / Error State ----
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // ---- Filter State ----
  /// Only one filter can be active at a time (matches HomeScreen chip behaviour).
  final RxString selectedFilter = ''.obs;

  // ---- Pagination (mirrors HomeController) ----
  int _currentPage = 1;
  final int _pageLimit = 20;
  bool _hasMoreData = true;

  // ---- Carousel Controller ----
  late PageController pageController;

  // ---- Marker icon cache ----
  late BitmapDescriptor _selectedIcon;
  late BitmapDescriptor _unselectedIcon;
  bool _iconsReady = false;

  // ---- Services (registered lazily, same as HomeController) ----
  late final HomeService _homeService;

  // ---- Initial camera ----
  /// Computed in onInit() from LocationController if available; falls back to a
  /// neutral world view that will be overridden once restaurants load.
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(20.5937, 78.9629), // Centre of India as a neutral fallback
    zoom: 5,
  );

  CameraPosition get initialCameraPosition => _initialCameraPosition;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.85);

    // Register HomeService dependencies if not already registered (same guard as HomeController)
    if (!Get.isRegistered<HomeRepository>()) Get.put(HomeRepository());
    if (!Get.isRegistered<HomeApiService>()) Get.put(HomeApiService());
    if (!Get.isRegistered<HomeService>()) Get.put(HomeService());
    _homeService = Get.find<HomeService>();

    // Snap initial camera to user's GPS position if already fetched
    _applyUserLocationToCamera();

    // Pre-cache marker icons then load data
    _initMarkerIcons().then((_) => fetchRestaurants());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Initialisation helpers
  // ---------------------------------------------------------------------------

  /// Try to set the initial camera position from the LocationController.
  void _applyUserLocationToCamera() {
    try {
      final lc = Get.find<LocationController>();
      if (lc.hasLocation.value) {
        _initialCameraPosition = CameraPosition(
          target: LatLng(lc.latitude.value, lc.longitude.value),
          zoom: 13,
        );
      }
    } catch (_) {
      // LocationController not registered yet — keep neutral fallback
    }
  }

  /// Cache two BitmapDescriptor instances so we never allocate new ones on every swipe.
  Future<void> _initMarkerIcons() async {
    _selectedIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen, // Primary brand colour approximation
    );
    _unselectedIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed, // Default / unselected
    );
    _iconsReady = true;
  }

  // ---------------------------------------------------------------------------
  // Data fetching
  // ---------------------------------------------------------------------------

  /// Fetch restaurants from API. When [reset] is true, pagination starts over.
  Future<void> fetchRestaurants({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _hasMoreData = true;
      restaurants.clear();
    }
    if (!_hasMoreData) return;

    // Map selected filter label to enum value
    final RestaurantFilters? apiFilter = _mapLabelToFilter(selectedFilter.value);

    double? lat;
    double? lng;

    // Send lat/lng for "Near you" filter (matches HomeController behaviour)
    if (apiFilter == RestaurantFilters.near_you ||
        selectedFilter.value.isEmpty) {
      try {
        final lc = Get.find<LocationController>();
        if (lc.hasLocation.value) {
          lat = lc.latitude.value;
          lng = lc.longitude.value;
        }
      } catch (_) {}
    }

    // For "Near you" filter the backend uses lat/lng rather than a filter param
    final RestaurantFilters? filterParam =
        (apiFilter != null && apiFilter != RestaurantFilters.near_you)
            ? apiFilter
            : null;

    _homeService.loadRestaurants(
      page: _currentPage,
      limit: _pageLimit,
      filter: filterParam,
      lat: lat,
      lng: lng,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: (List<RestaurantModel> list, RestaurantMetadata metadata) {
        if (_currentPage == 1) {
          restaurants.assignAll(list);
        } else {
          restaurants.addAll(list);
        }
        _hasMoreData = metadata.hasMore;
        _currentPage++;

        // Rebuild all markers with the fresh list
        _rebuildAllMarkers();

        // Select and animate to the first restaurant
        if (restaurants.isNotEmpty) {
          _setSelectedRestaurant(restaurants.first, animate: true);
        }

        // Kick carousel back to page 0 on a fresh load / filter change
        if (reset && pageController.hasClients) {
          pageController.jumpToPage(0);
        }
      },
      onError: (error) {
        AppLogger.e('MapController', 'Failed to fetch restaurants', error);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Marker management
  // ---------------------------------------------------------------------------

  /// Full rebuild — called only on initial load / filter change / data refresh.
  void _rebuildAllMarkers() {
    if (!_iconsReady) return;
    final newMarkers = <Marker>{};
    for (final r in restaurants) {
      final isSelected = r.id == _selectedMarkerId;
      newMarkers.add(_buildMarker(r, isSelected: isSelected));
    }
    markers
      ..clear()
      ..addAll(newMarkers);
  }

  /// Efficient update — swap icon for the old selected marker and the new one only.
  void _updateMarkerSelection(String newId, String? oldId) {
    if (!_iconsReady) return;

    final updated = <Marker>{};
    for (final m in markers) {
      if (m.markerId.value == newId) {
        updated.add(m.copyWith(iconParam: _selectedIcon));
      } else if (m.markerId.value == oldId) {
        updated.add(m.copyWith(iconParam: _unselectedIcon));
      } else {
        updated.add(m);
      }
    }
    markers
      ..clear()
      ..addAll(updated);
  }

  Marker _buildMarker(RestaurantModel r, {bool isSelected = false}) {
    return Marker(
      markerId: MarkerId(r.id),
      position: LatLng(r.location.latitude, r.location.longitude),
      icon: isSelected ? _selectedIcon : _unselectedIcon,
      infoWindow: InfoWindow(
        title: r.restaurantName,
        snippet: r.address.fullAddress,
      ),
      onTap: () => _onMarkerTapped(r),
    );
  }

  void _onMarkerTapped(RestaurantModel restaurant) {
    _setSelectedRestaurant(restaurant, animate: false);
    final index = restaurants.indexOf(restaurant);
    if (index != -1 && pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Central method to update selection state: marker icons + selectedRestaurant observable.
  void _setSelectedRestaurant(RestaurantModel r, {bool animate = false}) {
    final oldId = _selectedMarkerId;
    _selectedMarkerId = r.id;
    selectedRestaurant.value = r;

    if (oldId != _selectedMarkerId) {
      _updateMarkerSelection(r.id, oldId);
    }

    if (animate) {
      _animateCamera(r.location.latitude, r.location.longitude);
    }
  }

  // ---------------------------------------------------------------------------
  // Carousel page swipe
  // ---------------------------------------------------------------------------

  void onPageChanged(int index) {
    if (index >= 0 && index < restaurants.length) {
      final restaurant = restaurants[index];
      _setSelectedRestaurant(restaurant, animate: true);
    }
  }

  // ---------------------------------------------------------------------------
  // Camera animation
  // ---------------------------------------------------------------------------

  Future<void> _animateCamera(double lat, double lng) async {
    if (!mapController.isCompleted) return;
    final controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15),
      ),
    );
  }

  /// Move the camera to the user's current position (used externally if needed).
  Future<void> animateToUserLocation() async {
    try {
      final lc = Get.find<LocationController>();
      if (lc.hasLocation.value) {
        await _animateCamera(lc.latitude.value, lc.longitude.value);
      }
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Filter chips
  // ---------------------------------------------------------------------------

  /// Toggle a filter chip. If already selected, deselect and reload all.
  void updateFilter(String label) {
    if (selectedFilter.value == label) {
      selectedFilter.value = '';
    } else {
      selectedFilter.value = label;
    }
    fetchRestaurants(reset: true);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  RestaurantFilters? _mapLabelToFilter(String label) {
    switch (label) {
      case 'Near you':
        return RestaurantFilters.near_you;
      case 'Top rated':
        return RestaurantFilters.top_rated;
      case 'Open now':
        return RestaurantFilters.open_now;
      case 'Certified':
        return RestaurantFilters.certified;
      default:
        return null;
    }
  }
}
