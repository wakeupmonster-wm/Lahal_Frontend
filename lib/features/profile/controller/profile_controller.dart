import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/data/datasources/local/user_prefrence.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/features/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final UserPreferences _prefs = UserPreferences();

  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      final response = await _profileRepo.getProfile();
      log("body for fetchUserProfile😁: $response");
      if (response.isSuccess && response.data != null) {
        userProfile.value = UserProfile.fromJson(response.data);
      }
    } catch (e) {
      log("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    isLoggingOut.value = true;
    try {
      final refreshToken = await _prefs.getRefreshToken();
      final deviceToken = await _prefs.getDeviceToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _profileRepo.logout(
          refreshToken: refreshToken,
          deviceToken: deviceToken ?? "",
        );
      }
      AppSnackBar.showToast(message: "Logged out successfully");

      // Clear all local data and controllers
      await _prefs.clearAll();
      Get.deleteAll();

      if (context.mounted) {
        context.go(AppRoutes.signInScreen);
      }
    } catch (e) {
      log("Logout Error: $e");
      // Even if API fails, we should clear local data
      await _prefs.clearAll();
      Get.deleteAll();
      if (context.mounted) {
        context.go(AppRoutes.signInScreen);
      }
    } finally {
      isLoggingOut.value = false;
    }
  }
}
