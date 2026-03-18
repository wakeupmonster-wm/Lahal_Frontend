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
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isEmailEditable = true.obs;
  final RxString selectedGender = ''.obs;
  final RxBool isGenderExpanded = false.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);

  final RxBool hasChanges = false.obs;
  final Map<String, dynamic> _initialData = {};

  final genderOptions = ['male', 'female', 'other'];

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();

    // Add listeners to track changes
    nameController.addListener(_checkChanges);
    emailController.addListener(_checkChanges);
    dobController.addListener(_checkChanges);
    genderController.addListener(_checkChanges);
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
      nameController.text = user.userName;
      phoneController.text = user.phone;
      emailController.text = user.email ?? '';

      // Handle DOB formatting for UI (API: yyyy-MM-dd, UI: dd/MM/yyyy)
      String displayDob = '';
      if (user.dob.isNotEmpty) {
        try {
          DateTime date = DateTime.parse(user.dob);
          displayDob = DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          log("Error parsing dob from API: $e");
          displayDob = user.dob;
        }
      }
      dobController.text = displayDob;

      selectedGender.value = user.gender.toLowerCase();
      genderController.text = user.gender;

      // Store initial data for change comparison
      _initialData['userName'] = nameController.text;
      _initialData['email'] = emailController.text;
      _initialData['dob'] = dobController.text;
      _initialData['gender'] = selectedGender.value;

      hasChanges.value = false;
    }
  }

  void _checkChanges() {
    bool changed =
        nameController.text != _initialData['userName'] ||
        emailController.text != _initialData['email'] ||
        dobController.text != _initialData['dob'] ||
        selectedGender.value != _initialData['gender'] ||
        pickedImage.value != null;

    if (hasChanges.value != changed) {
      hasChanges.value = changed;
    }
  }

  void toggleGenderExpanded() {
    isGenderExpanded.value = !isGenderExpanded.value;
  }

  void selectGender(String gender) {
    selectedGender.value = gender.toLowerCase();
    genderController.text = gender;
    isGenderExpanded.value = false;
    _checkChanges();
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(
      const Duration(days: 365 * 18),
    );
    try {
      if (dobController.text.isNotEmpty) {
        initialDate = DateFormat('dd/MM/yyyy').parse(dobController.text);
      }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      _checkChanges();
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
        _checkChanges();
      }
    } catch (e) {
      AppSnackBar.showToast(message: "Failed to pick image: $e");
    }
  }

  void removeImage() {
    pickedImage.value = null;
    _checkChanges();
  }

  Future<void> updateProfileImage(File file) async {
    isLoading.value = true;
    try {
      final response = await _profileRepo.updateProfileImage(file);
      if (response.isSuccess) {
        return; // Success handled by updateProfileDetails if called together, or independently
      } else {
        AppSnackBar.showToast(message: response.message);
        throw Exception(response.message);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileDetails(BuildContext context) async {
    if (!hasChanges.value) {
      AppSnackBar.showToast(message: "You haven't changed anything.");
      return;
    }

    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // 1. If image changed, upload it first
      if (pickedImage.value != null) {
        await _profileRepo.updateProfileImage(pickedImage.value!);
      }

      // 2. Prepare and send profile details
      String formattedDob = dobController.text;
      if (dobController.text.isNotEmpty) {
        try {
          DateTime date = DateFormat('dd/MM/yyyy').parse(dobController.text);
          formattedDob = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          log("Error formatting dob for API: $e");
        }
      }

      final body = {
        'userName': nameController.text,
        'email': emailController.text,
        'dob': formattedDob,
        'gender': selectedGender.value,
      };

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
