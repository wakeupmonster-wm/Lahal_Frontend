import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  final RxList<File> selectedImages = <File>[].obs; // Typically food images
  final RxString selectedImagesError = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFormValid = false.obs;
  final Rx<AutovalidateMode> autovalidateMode = AutovalidateMode.disabled.obs;

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
      selectedImagesError.value = '';
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    if (selectedImages.isEmpty &&
        autovalidateMode.value != AutovalidateMode.disabled) {
      selectedImagesError.value = "Please add at least one photo.";
    }
  }

  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) {
      autovalidateMode.value = AutovalidateMode.onUserInteraction;
      return;
    }

    if (selectedImages.isEmpty) {
      selectedImagesError.value = "Please add at least one photo.";
      autovalidateMode.value = AutovalidateMode.onUserInteraction;
      return;
    }

    isLoading.value = true;

    try {
      final Map<String, String> fields = {
        "restaurantName": restaurantNameController.text.trim(),
        "address": jsonEncode({
          "fullAddress": addressController.text.trim(),
          "city": cityController.text.trim(),
          "state": stateController.text.trim(),
          "country": countryController.text.trim(),
          "pincode": pincodeController.text.trim(),
        }),
        "halalStatus": selectedHalalStatus.value,
        "additionalNote": additionalNoteController.text.trim(),
      };
      log("fields: ---------------------${fields.toString()}");

      final Map<String, List<File>> multipartFiles = {
        "restaurantImgs": selectedImages.toList(),
        // "restaurantImgs": restaurantImages.toList(),
      };

      final response = await repository.addRestaurantRequest(
        fields: fields,
        multipartFiles: multipartFiles,
      );

      if (response.isSuccess) {
        log("response: ---------------------${response.toString()}");
        Fluttertoast.showToast(
          msg: "Restaurant request sent successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        clearForm();
      } else {
        log("response: ---------------------${response.toString()}");
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
    selectedImagesError.value = '';
    // restaurantImages.clear();
    autovalidateMode.value = AutovalidateMode.disabled;
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
