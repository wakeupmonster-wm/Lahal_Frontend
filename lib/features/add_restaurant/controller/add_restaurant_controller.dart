import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../model/add_restaurant_model.dart';
import '../repo/add_restaurant_repository.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';

class AddRestaurantController extends GetxController {
  final AddRestaurantRepository repository = AddRestaurantRepository();
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  // Observable fields
  final restaurantNameController = TextEditingController();
  final addressController = TextEditingController(); // Full Address
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final additionalNoteController = TextEditingController();

  final RxString selectedHalalStatus = 'Fully Halal'.obs;
  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes to validate form
    restaurantNameController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    cityController.addListener(_validateForm);
    stateController.addListener(_validateForm);
    countryController.addListener(_validateForm);
    pincodeController.addListener(_validateForm);
    ever(selectedImages, (_) => _validateForm());
  }

  void _validateForm() {
    isFormValid.value =
        restaurantNameController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        stateController.text.trim().isNotEmpty &&
        countryController.text.trim().isNotEmpty &&
        pincodeController.text.trim().isNotEmpty &&
        selectedImages.isNotEmpty;
  }

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
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (selectedImages.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please add at least one restaurant photo.",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Step 1: Upload Images
      final uploadResponse = await repository.uploadFoodImages(selectedImages);
      if (!uploadResponse.isSuccess) {
        Fluttertoast.showToast(
          msg: "Image upload failed: ${uploadResponse.message}",
          backgroundColor: Colors.redAccent,
        );
        return;
      }

      // Parse uploaded images from response
      final List<dynamic> dataList = uploadResponse.data as List<dynamic>;
      final List<FoodImage> foodImages = dataList
          .map((item) => FoodImage.fromJson(item as Map<String, dynamic>))
          .toList();

      // Step 2: Submit Restaurant Request
      final address = RestaurantAddress(
        fullAddress: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        country: countryController.text.trim(),
        pincode: pincodeController.text.trim(),
      );

      final restaurantRequest = AddRestaurantRequest(
        restaurantName: restaurantNameController.text.trim(),
        address: address,
        halalStatus: selectedHalalStatus.value,
        foodsImages: foodImages,
      );

      final response = await repository.submitRestaurantRequest(
        restaurantRequest.toJson(),
      );

      if (response.isSuccess) {
        Fluttertoast.showToast(
          msg: "Restaurant request sent successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        clearForm();
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (e is AppException) {
        if (e.rawBody != null && e.rawBody['errors'] != null) {
          final errors = e.rawBody['errors'];
          if (errors is List) {
            errorMsg = errors.join(', ');
          } else if (errors is Map) {
            errorMsg = errors.values.join(', ');
          } else {
            errorMsg = errors.toString();
          }
        } else {
          errorMsg = e.message;
        }
      }

      Fluttertoast.showToast(
        msg: errorMsg,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    formKey.currentState?.reset();
    restaurantNameController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pincodeController.clear();
    additionalNoteController.clear();
    selectedHalalStatus.value = 'Fully Halal';
    selectedImages.clear();
    _validateForm();
  }

  @override
  void onClose() {
    restaurantNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    additionalNoteController.dispose();
    super.onClose();
  }
}
