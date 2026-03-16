import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/features/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();

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
      log("body for updateprofiledetails: $response");
      if (response.isSuccess && response.data != null) {
        userProfile.value = UserProfile.fromJson(response.data);
      }
    } catch (e) {
      // AppSnackBar.showToast(message: "Failed to fetch profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    isLoggingOut.value = true;
    try {
      await _profileRepo.logout();
      AppSnackBar.showToast(message: "Logged out successfully");
      // Clear token/user data logic would go here
      context.go(AppRoutes.signInScreen);
    } catch (e) {
      AppSnackBar.showToast(message: "Logout failed. Please try again.");
    } finally {
      isLoggingOut.value = false;
    }
  }
}
