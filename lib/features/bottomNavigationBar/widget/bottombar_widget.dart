import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_sizer.dart';
import '../controller/bottom_navigationbar_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationWidget extends StatelessWidget {
  BottomNavigationWidget({super.key});
  final BottomNavController controller = Get.put(BottomNavController());
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sizer = SizeConfig(context);
    return Obx(() {
      final selected = controller.selectedIndex.value;

      return Stack(
        children: [
          Container(
            height: sizer.h(80),
            margin: EdgeInsets.only(top: sizer.h(30)),
            color: cs.onPrimary,
          ),
          Container(
            margin: EdgeInsets.only(bottom: sizer.h(6)),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.4),
                  blurRadius: 120,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: sizer.w(24), vertical: sizer.h(16)),
                  padding: EdgeInsets.symmetric(
                    horizontal: sizer.w(32),
                    vertical: sizer.h(22),
                  ),
                  decoration: BoxDecoration(
                    color: cs.onPrimary,
                    borderRadius: BorderRadius.circular(sizer.w(20)),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: cs.onSurface.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(controller.unselectedIcons.length, (
                      index,
                    ) {
                      final isActive = selected == index;
                      return GestureDetector(
                        onTap: () => controller.updateIndex(index),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              isActive ? controller.selectedIcons[index] : controller.unselectedIcons[index],
                              width: sizer.w(21),
                              height: sizer.h(21),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
