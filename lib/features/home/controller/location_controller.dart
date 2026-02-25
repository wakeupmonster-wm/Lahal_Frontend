import 'dart:developer';
import 'package:get/get.dart';
import 'package:lahal_application/data/services/location_service.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/components/location/location_permission_sheet.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';

class LocationController extends GetxController {
  final isLocationLoading = false.obs;
  final currentAddress =
      'Melbourne, Victoria (VIC)'.obs; // Default from HomeController
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    fetchLocation(openSettings: false);
  }

  Future<void> fetchLocation({bool openSettings = true}) async {
    try {
      isLocationLoading.value = true;

      final position = await LocationService.getCurrentPosition();
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      currentAddress.value = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );
    } on LocationPermissionDeniedException catch (e) {
      log(e.toString());
      // Show bottom sheet instead of just a toast
      if (Get.context != null) {
        LocationPermissionSheet.show(
          Get.context!,
          onEnable: () async {
            // Try to fetch again, which will trigger permission request or settings
            await fetchLocation(openSettings: true);
          },
          onManualSearch: () {
            Get.context!.push(AppRoutes.changeLocationScreen);
          },
        );
      } else {
        AppSnackBar.showToast(message: e.message);
      }

      // Open app settings so user can enable permission manually
      if (openSettings) {
        await LocationService.openAppSettings();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLocationLoading.value = false;
    }
  }
}
