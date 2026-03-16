import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/splash/controller/splash_controller.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initSplash(context);
    });

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.primaryColor,
      child: Lottie.asset(AppAssets.splashAnimation, fit: BoxFit.contain),
    );
  }
}
