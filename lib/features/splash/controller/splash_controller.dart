import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/data/datasources/local/user_prefrence.dart';
import 'package:lahal_application/utils/network/network_controller.dart' show NetworkManager;
import 'package:lahal_application/utils/routes/app_pages.dart';

class SplashController extends GetxController {
  bool _hasInitialized = false;

  void initSplash(BuildContext context) {
    if (_hasInitialized) return;
    _hasInitialized = true;

    Get.put(NetworkManager(context));
    
    Future.delayed(const Duration(seconds: 2), () async {
      final userPref = UserPreferences();
      final token = await userPref.getToken();
      
      if (context.mounted) {
        if (token != null && token.isNotEmpty) {
          context.go(AppRoutes.bottomNavigationBar);
        } else {
          context.go(AppRoutes.signInScreen);
        }
      }
    });
  }
}
