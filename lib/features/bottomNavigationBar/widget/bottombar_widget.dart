import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import '../../../utils/constants/app_sizer.dart';
import '../controller/bottom_navigationbar_controller.dart';

class BottomNavigationWidget extends StatelessWidget {
  BottomNavigationWidget({super.key});
  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final sizer = SizeConfig(context);
    final mq = MediaQuery.of(context);

    return Obx(() {
      final selected = controller.selectedIndex.value;

      return Container(
        height: 70 + mq.padding.bottom,
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(
            top: BorderSide(
              color: cs.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: mq.padding.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(controller.unselectedIcons.length, (index) {
              final isActive = selected == index;
              final iconPath = isActive
                  ? controller.selectedIcons[index]
                  : controller.unselectedIcons[index];
              final label = controller.labels[index];

              return GestureDetector(
                onTap: () => controller.updateIndex(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: mq.size.width / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(iconPath, width: 24, height: 24),
                      const SizedBox(height: 4),
                      AppText(
                        label,
                        size: AppTextSize.s10,
                        weight: isActive
                            ? AppTextWeight.bold
                            : AppTextWeight.medium,
                        color: isActive ? cs.primary : tx.subtle,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
