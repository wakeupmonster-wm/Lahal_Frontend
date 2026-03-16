import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/prey/controller/prayer_controller.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class PrayerHeader extends StatelessWidget {
  const PrayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrayerController>();
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            cs.primary.withOpacity(0.0),
            cs.primary.withOpacity(0.1),
            cs.primary.withOpacity(0.4),
            cs.surface,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: tok.gap.xl),
            // Clock Time
            Obx(
              () => AppText(
                controller.currentTime.value,
                size: AppTextSize.s64,
                weight: AppTextWeight.bold,
                color: const Color(0xFF047861),
              ),
            ),
            SizedBox(height: tok.gap.md),
            // Location Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: tok.gap.md,
                vertical: tok.gap.xxs,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF047861).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Icon(Icons.location_on, size: 14, color: Colors.white),
                  SvgPicture.asset(
                    AppSvg.locationNobcakgroundIcon,
                    width: 14,
                    height: 14,
                    color: Colors.white,
                  ),
                  SizedBox(width: tok.gap.xxxs),
                  Obx(
                    () => AppText(
                      controller.currentLocation.value,
                      size: AppTextSize.s12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SvgPicture.asset(
              AppSvg.mosqueImage,
              width: width * 0.100,
              height: height * 0.235,
              fit: BoxFit.fitHeight,
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }
}

//----old code

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:lahal_application/features/prey/controller/prayer_controller.dart';
// import 'package:lahal_application/utils/constants/app_svg.dart';
// import 'package:lahal_application/utils/theme/app_tokens.dart';
// import 'package:lahal_application/utils/theme/text/app_text.dart';
// import 'package:lahal_application/utils/theme/text/app_text_color.dart';
// import 'package:lahal_application/utils/theme/text/app_typography.dart';

// class PrayerHeader extends StatelessWidget {
//   const PrayerHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<PrayerController>();
//     final tok = Theme.of(context).extension<AppTokens>()!;
//     final tx = Theme.of(context).extension<AppTextColors>()!;
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       width: double.infinity,
//       height: 400, // Slightly increased height
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             cs.primary.withOpacity(0.0),
//             cs.primary.withOpacity(0.1),
//             cs.primary.withOpacity(0.4),

//             cs.surface,
//           ],
//         ),
//       ),
//       child: Column(
//         children: [
//           SizedBox(height: tok.gap.xxl),
//           SizedBox(height: tok.gap.xxl),
//           // Clock Time
//           Obx(
//             () => AppText(
//               controller.currentTime.value,
//               size: AppTextSize.s64,
//               weight: AppTextWeight.bold,
//               color: const Color(0xFF047861),
//             ),
//           ),
//           SizedBox(height: tok.gap.md),
//           // Location Badge
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: tok.gap.md,
//               vertical: tok.gap.xxs,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFF047861).withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.location_on, size: 14, color: Colors.white),
//                 const SizedBox(width: 4),
//                 Obx(
//                   () => AppText(
//                     controller.currentLocation.value,
//                     size: AppTextSize.s12,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           SvgPicture.asset(
//             AppSvg.mosqueImage,
//             width: 400,
//             height: 200,
//             fit: BoxFit.fitHeight,
//             alignment: Alignment.bottomCenter,
//           ),
//         ],
//       ),
//     );
//   }
// }
