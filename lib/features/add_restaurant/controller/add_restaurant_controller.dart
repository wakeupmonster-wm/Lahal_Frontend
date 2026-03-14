import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/add_restaurant_model.dart';
import '../repo/add_restaurant_repository.dart';

class AddRestaurantController extends GetxController {
  final AddRestaurantRepository repository = AddRestaurantRepository();
  final ImagePicker _picker = ImagePicker();

  // Observable fields
  var restaurantNameController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var additionalNoteController = TextEditingController();

  var selectedHalalStatus = 'Fully Halal'.obs;
  var selectedImages = <File>[].obs;
  var isLoading = false.obs;

  final List<String> halalStatuses = [
    'Fully Halal',
    'Halal Options Available',
    'Not Sure',
  ];

  void setHalalStatus(String status) {
    selectedHalalStatus.value = status;
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images.map((image) => File(image.path)));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitRequest() async {
    if (restaurantNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty) {
      // SnackBar(content:   )
      // Get.snackbar(
      //   "Error",
      //   "Please fill in all required fields",
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      return;
    }

    if (selectedImages.isEmpty) {
      // Get.snackbar(
      //   "Error",
      //   "Please add at least one restaurant photo",
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      return;
    }

    isLoading.value = true;

    final restaurant = AddRestaurantModel(
      name: restaurantNameController.text,
      address: addressController.text,
      city: cityController.text,
      halalStatus: selectedHalalStatus.value,
      images: selectedImages.toList(),
      additionalNote: additionalNoteController.text,
    );

    final success = await repository.submitRestaurantRequest(restaurant);

    isLoading.value = false;

    if (success) {
      // Get.snackbar(
      //   "Success",
      //   "Restaurant request sent successfully!",
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      clearForm();
    } else {
      // Get.snackbar(
      //   "Error",
      //   "Failed to send request. Please try again.",
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  void clearForm() {
    restaurantNameController.clear();
    addressController.clear();
    cityController.clear();
    additionalNoteController.clear();
    selectedHalalStatus.value = 'Fully Halal';
    selectedImages.clear();
  }

  @override
  void onClose() {
    restaurantNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    additionalNoteController.dispose();
    super.onClose();
  }
}
