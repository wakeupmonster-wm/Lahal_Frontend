import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/controller/profile_controller.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:intl/intl.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';

class EditProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final ProfileController _profileController = Get.find<ProfileController>();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  final RxBool isLoading = false.obs;
  // final RxBool isPhoneEditable = false.obs;
  final RxBool isEmailEditable = false.obs;
  final RxString selectedGender = ''.obs;
  final RxBool isGenderExpanded = false.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);

  final genderOptions = ['Male', 'Female', 'Other'];

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data or fetch from API
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.onClose();
  }

  void fetchUserProfile() {
    final user = _profileController.userProfile.value;
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phoneNumber;
      emailController.text = user.email;

      // Handle DOB formatting for UI
      String displayDob = user.dob;
      if (user.dob.contains('-')) {
        try {
          DateTime date = DateFormat('yyyy-MM-dd').parse(user.dob);
          displayDob = DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          log("Error parsing dob from API: $e");
        }
      }
      dobController.text = displayDob;

      selectedGender.value = user.gender;
      genderController.text = user.gender;
    }
  }

  void togglePhoneEditable() {
    // isPhoneEditable.value = !isPhoneEditable.value;
  }

  void toggleEmailEditable() {
    isEmailEditable.value = !isEmailEditable.value;
  }

  void toggleGenderExpanded() {
    isGenderExpanded.value = !isGenderExpanded.value;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
    genderController.text = gender;
    isGenderExpanded.value = false;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      if (image != null) {
        pickedImage.value = File(image.path);
        // Automatically start upload when image is picked
        await updateProfileImage(pickedImage.value!);
      }
    } catch (e) {
      AppSnackBar.showToast(message: "Failed to pick image: $e");
    }
  }

  void removeImage() {
    pickedImage.value = null;
  }

  // Update profile image api
  Future<void> updateProfileImage(File file) async {
    isLoading.value = true;
    try {
      final response = await _profileRepo.updateProfileImage(file);
      log("body for updateprofileimage😁: $response");
      if (response.isSuccess) {
        AppSnackBar.showToast(message: "Profile image updated successfully");
        await _profileController.fetchUserProfile();
      } else {
        AppSnackBar.showToast(message: response.message);
      }
    } catch (e) {
      AppSnackBar.showToast(message: "Image update failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile details api
  Future<void> updateProfileDetails(BuildContext context) async {
    isLoading.value = true;
    try {
      // Convert dd/MM/yyyy to yyyy-MM-dd for API
      String formattedDob = dobController.text;
      try {
        if (dobController.text.isNotEmpty) {
          DateTime date = DateFormat('dd/MM/yyyy').parse(dobController.text);
          formattedDob = DateFormat('yyyy-MM-dd').format(date);
        }
      } catch (e) {
        log("Error parsing dob: $e");
      }

      final body = {
        'userName': nameController.text,
        // 'email': emailController.text, //need to add email
        'dob': formattedDob,
        'gender': selectedGender.value,
      };
      log("body for updateprofiledetails😁: $body");

      final response = await _profileRepo.updateProfile(body);
      if (response.isSuccess) {
        AppSnackBar.showToast(message: "Profile updated successfully");
        await _profileController.fetchUserProfile();
        if (context.mounted) {
          context.pop();
        }
      } else {
        AppSnackBar.showToast(message: response.message);
      }
    } catch (e) {
      AppSnackBar.showToast(message: "Update failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void saveProfile(BuildContext context) async {
    await updateProfileDetails(context);
  }
}
