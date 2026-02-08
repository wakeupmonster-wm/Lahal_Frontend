import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();

  final RxBool isLoggingOut = false.obs;

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
