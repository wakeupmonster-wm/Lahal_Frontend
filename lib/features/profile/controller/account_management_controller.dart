import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/data/datasources/local/user_prefrence.dart';

class AccountManagementController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final UserPreferences _prefs = UserPreferences();

  final RxBool isLoading = false.obs;

  Future<void> deleteAccount(BuildContext context) async {
    isLoading.value = true;
    try {
      final response = await _profileRepo.deleteAccount();
      if (response.isSuccess) {
        AppSnackBar.showToast(message: "Account deleted successfully");
        await _logoutLocally(context);
      } else {
        AppSnackBar.showToast(message: response.message);
      }
    } catch (e) {
      AppSnackBar.showToast(
        message: "Failed to delete account. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _logoutLocally(BuildContext context) async {
    await _prefs.removeUser();
    if (context.mounted) {
      context.go(AppRoutes.signInScreen);
    }
  }
}
