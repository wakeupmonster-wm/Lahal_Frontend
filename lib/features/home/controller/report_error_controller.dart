import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/repo/report_error_repository.dart';
import 'package:lahal_application/features/home/services/report_error_api_service.dart';
import 'package:lahal_application/features/home/services/report_error_service.dart';
import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';

class ReportErrorController extends GetxController {
  final Map<String, bool> options = {
    'Phone Number': false,
    'Address': false,
    'This place has closed down': false,
    'Other': false,
  }.obs;

  final moreInfoController = TextEditingController();

  late final ReportErrorService _service;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<ReportErrorRepository>()) Get.put(ReportErrorRepository());
    if (!Get.isRegistered<ReportErrorApiService>()) Get.put(ReportErrorApiService());
    if (!Get.isRegistered<ReportErrorService>()) Get.put(ReportErrorService());
    
    _service = Get.find<ReportErrorService>();
  }

  // Computed property to check if at least one option is selected
  bool get isSubmitEnabled => options.containsValue(true);

  void toggleOption(String key) {
    if (options.containsKey(key)) {
      options[key] = !options[key]!;
    }
  }

  void submit(BuildContext context, String restaurantId) {
    if (!isSubmitEnabled) return;

    // Validation: If "Other" is selected, force user to type something in More Info
    if (options['Other'] == true && moreInfoController.text.trim().isEmpty) {
      AppSnackBar.showToast(message: "Please provide more details for 'Other' reason.");
      return;
    }

    // Collect checked reasons
    List<String> selectedReasons = [];
    options.forEach((key, value) {
      if (value) selectedReasons.add(key);
    });

    _service.submitReport(
      restaurantId: restaurantId,
      reasons: selectedReasons,
      message: moreInfoController.text.trim(),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: () {
        context.pop();
      },
    );
  }

  @override
  void onClose() {
    moreInfoController.dispose();
    super.onClose();
  }
}
