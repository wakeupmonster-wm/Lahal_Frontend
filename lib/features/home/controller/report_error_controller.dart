import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ReportErrorController extends GetxController {
  final Map<String, bool> options = {
    'Phone Number': false,
    'Address': false,
    'This place has closed down': false,
    'Other': false,
  }.obs;

  final moreInfoController = TextEditingController();

  // Computed property to check if at least one option is selected
  bool get isSubmitEnabled => options.containsValue(true);

  void toggleOption(String key) {
    if (options.containsKey(key)) {
      options[key] = !options[key]!;
    }
  }

  void submit(BuildContext context) {
    if (isSubmitEnabled) {
      // Logic to submit the report
      print('Reporting error:');
      options.forEach((key, value) {
        if (value) print('- $key');
      });
      print('More info: ${moreInfoController.text}');

      context.pop();
      Fluttertoast.showToast(msg: "Report Submitted");
    }
  }

  @override
  void onClose() {
    moreInfoController.dispose();
    super.onClose();
  }
}
