import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/model/restaurant_details_model.dart';
import 'package:lahal_application/features/home/repo/restaurant_details_repository.dart';
import 'package:lahal_application/features/home/services/restaurant_details_api_service.dart';
import 'package:lahal_application/features/home/services/restaurant_details_service.dart';
import 'package:lahal_application/features/home/view/widgets/redirecting_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsController extends GetxController {
  late final RestaurantDetailsService _service;

  final Rxn<RestaurantDetailsModel> restaurant = Rxn<RestaurantDetailsModel>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<int> expandedReviewIndices = <int>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<RestaurantDetailsRepository>())
      Get.put(RestaurantDetailsRepository());
    if (!Get.isRegistered<RestaurantDetailsApiService>())
      Get.put(RestaurantDetailsApiService());
    if (!Get.isRegistered<RestaurantDetailsService>())
      Get.put(RestaurantDetailsService());

    _service = Get.find<RestaurantDetailsService>();
  }

  void fetchRestaurantDetails(String id) {
    if (id.isEmpty) return;

    // Clear old state when switching to a new restaurant
    restaurant.value = null;
    error.value = '';
    expandedReviewIndices.clear();

    _service.loadRestaurantDetails(
      restaurantId: id,
      isLoading: isLoading,
      errorMessage: error,
      onSuccess: (details) {
        restaurant.value = details;
      },
    );
  }

  void toggleReviewExpansion(int index) {
    if (expandedReviewIndices.contains(index)) {
      expandedReviewIndices.remove(index);
    } else {
      expandedReviewIndices.add(index);
    }
  }

  void toggleFavorite() {
    // Logic to toggle favorite status
  }

  void shareRestaurant() {
    // Logic to share restaurant
  }

  void callRestaurant() {
    // Logic to trigger a phone call
    print("on tap of Direction");
  }

  Future<void> getDirections(BuildContext context) async {
    final res = restaurant.value;
    if (res == null) return;

    final lat = res.location.latitude;
    final lng = res.location.longitude;
    final name = Uri.encodeComponent(res.restaurantName);

    // Show 3 second timer bottom sheet
    final bool completed = await RedirectingSnackbar.show(context);

    if (completed) {
      Uri mapUri;
      if (GetPlatform.isIOS) {
        mapUri = Uri.parse("maps://?q=$name&ll=$lat,$lng");
      } else {
        // Android Google Maps Intent
        mapUri = Uri.parse("geo:$lat,$lng?q=$lat,$lng($name)");
      }

      try {
        if (await canLaunchUrl(mapUri)) {
          await launchUrl(mapUri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback to web google maps if intent fails
          final webUri = Uri.parse(
            "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
          );
          if (await canLaunchUrl(webUri)) {
            await launchUrl(webUri, mode: LaunchMode.externalApplication);
          } else {
            Get.snackbar("Error", "Could not open map.");
          }
        }
      } catch (e) {
        Get.snackbar("Error", "Could not open map.");
      }
    }
  }
}
