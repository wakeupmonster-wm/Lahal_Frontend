import 'package:flutter/material.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_sizer.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/components/text/app_text.dart';
import 'package:lahal_application/utils/network/network_controller.dart'
    show NetworkManager;
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    Get.put(NetworkManager(context));
    Future.delayed(const Duration(seconds: 2), () {
      // context.go(AppRoutes.bottomNavigationBar);
      context.go(AppRoutes.signInScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final sizer = SizeConfig(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.primaryColor,
      child:
          // Center(
          //   child: AppText(
          //     "Lahal",
          //     size: AppTextSize.s24,
          //     weight: AppTextWeight.bold,
          //     color: AppColor.white,
          //   ),
          // ),
          Lottie.asset(AppAssets.splashAnimation, fit: BoxFit.contain),
    );
  }
}
