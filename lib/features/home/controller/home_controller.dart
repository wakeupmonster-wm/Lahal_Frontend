import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  void onStackFinished() {
    debugPrint('Stack finished');
  }
}
