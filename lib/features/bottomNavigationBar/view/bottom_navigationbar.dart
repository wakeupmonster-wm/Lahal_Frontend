import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lahal_application/utils/constants/app_sizer.dart';
import '../controller/bottom_navigationbar_controller.dart';
import '../widget/bottombar_widget.dart';

class BottomNavigationbar extends StatelessWidget {
  BottomNavigationbar({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
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
            Positioned(
              bottom: sizer.h(0),
              left: 0,
              right: 0,
              child: BottomNavigationWidget(),
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
