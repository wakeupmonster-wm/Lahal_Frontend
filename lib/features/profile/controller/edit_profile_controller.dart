import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';
import 'package:intl/intl.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';

class EditProfileController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPhoneEditable = false.obs;
  final RxBool isEmailEditable = false.obs;
  final RxString selectedGender = ''.obs;
  final RxBool isGenderExpanded = false.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);

  final genderOptions = ['Male', 'Female'];

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

  void fetchUserProfile() async {
    // For now using dummy data as per image
    nameController.text = "ddjdl";
    phoneController.text = "7965485686";
    emailController.text = "";
    dobController.text = "";
    selectedGender.value = "";
    genderController.text = "";
  }

  void togglePhoneEditable() {
    isPhoneEditable.value = !isPhoneEditable.value;
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
      }
    } catch (e) {
      AppSnackBar.showToast(message: "Failed to pick image: $e");
    }
  }

  void removeImage() {
    pickedImage.value = null;
  }

  /*
  Future<void> updateProfileApi() async {
    isLoading.value = true;
    try {
      final body = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'gender': selectedGender.value,
      };
      
      // If there's an image, you might need to handle multipart upload
      // final response = await _profileRepo.updateProfile(body);
      
      AppSnackBar.showToast(message: "Profile updated successfully");
    } catch (e) {
      AppSnackBar.showToast(message: "Update failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
  */

  void saveProfile(BuildContext context) async {
    // Logic to save profile
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      context.pop();
      AppSnackBar.showToast(message: "Profile updated successfully");
    } finally {
      isLoading.value = false;
    }
  }
}
