import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lahal_application/utils/constants/app_sizer.dart';
import '../controller/bottom_navigationbar_controller.dart';
import '../widget/bottombar_widget.dart';

class BottomNavigationbar extends StatelessWidget {
  BottomNavigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());
    final sizer = SizeConfig(context);
    final mq = MediaQuery.sizeOf(context);

    return Scaffold(
      // BODY SCREENS
      body: Obx(
        () => Stack(
          //fit: StackFit.expand,
          children: [
            IndexedStack(
              index: controller.selectedIndex.value,
              children: controller.screens,
            ),
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                bottom: controller.isNavBarVisible.value ? 0 : -sizer.h(100),
                left: 0,
                right: 0,
                child: BottomNavigationWidget(),
              ),
            ),
          ],
        ),
      ),

      // NAV BAR
      //bottomNavigationBar: BottomNavigationWidget(),
      // Stack(
      //   children: [
      //     Container(
      //       height: sizer.h(80),
      //       decoration: BoxDecoration(
      //         color: Colors.transparent,
      //         borderRadius: BorderRadius.circular(sizer.w(20)),
      //         boxShadow: [
      //           BoxShadow(
      //             color: AppColor.primaryColor.withOpacity(0.20),
      //             blurRadius: 60,
      //             offset: const Offset(0, 0),
      //           ),
      //         ],
      //       ),
      //     ),
      //     BottomNavigationWidget(),
      //   ],
      // ),
    );
  }
}
