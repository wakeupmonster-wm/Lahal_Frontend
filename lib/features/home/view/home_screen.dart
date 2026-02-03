// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:lahal_application/utils/routes/app_pages.dart';
// import 'package:lahal_application/utils/theme/app_palette.dart';
// import 'package:lahal_application/utils/theme/app_tokens.dart';
// import 'package:lahal_application/utils/theme/text/app_text.dart';
// import 'package:lahal_application/utils/theme/text/app_text_color.dart'
//     show AppTextColors;

// import '../../../utils/components/text/app_text.dart';
// import '../../../utils/constants/app_sizer.dart';
// import '../../../utils/constants/app_svg.dart';
// import '../controller/home_controller.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sizer = SizeConfig(context);
//     final HomeController ctrl = Get.put(HomeController());
//     return Scaffold(
//       appBar: AppBar(
//         //  backgroundColor: Colors.transparent,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         toolbarHeight: sizer.h(64),

//         leading: Padding(
//           padding: EdgeInsets.only(left: sizer.w(24)),
//           child: SvgPicture.asset(AppSvg.logo),
//         ),

//         actions: [
//           GestureDetector(
//             onTap: () {
//               context.push(AppRoutes.noInternetScreen);
//             },
//             child: SvgPicture.asset(AppSvg.notification),
//           ),
//           SizedBox(width: sizer.w(18)),
//           SvgPicture.asset(AppSvg.filter),
//           SizedBox(width: sizer.w(24)),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: sizer.w(24),
//           vertical: sizer.h(12),
//         ),
//         child: Text("hellooooooooooo"),
//       ),
//     );
//   }

//   /// Card widget builder (same visual style)
//   Widget buildCard(
//     BuildContext context,
//     String imageUrl,
//     SizeConfig sizer,
//     int index,
//   ) {
//     final tx = Theme.of(context).extension<AppTextColors>()!;
//     final tok = Theme.of(context).extension<AppTokens>()!;
//     final cs = Theme.of(context).colorScheme;
//     final mq = MediaQuery.sizeOf(context);
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         height: mq.height * 0.73,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: AppPalette.golden.withValues(alpha: 0.4),
//             width: index == 2 ? 5 : 0,
//           ),
//           borderRadius: BorderRadius.circular(sizer.w(16)),
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: cs.primary.withValues(alpha: 0.12),
//               blurRadius: 12,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // top progress bars (decorative)
//             Positioned(
//               top: sizer.h(18),
//               left: sizer.w(18),
//               right: sizer.w(18),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 4,
//                       margin: const EdgeInsets.only(right: 6),
//                       decoration: BoxDecoration(
//                         color: cs.onPrimary,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 4,
//                       margin: const EdgeInsets.only(right: 6),
//                       decoration: BoxDecoration(
//                         color: cs.outline,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // bottom gradient and info
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               height: sizer.h(160),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(sizer.w(20)),
//                   ),
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.72),
//                       Colors.black.withOpacity(0.85),
//                     ],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//                 padding: EdgeInsets.all(sizer.w(16)),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // left: name/age/location
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             PlusJakartaSans(
//                               text: "MONICA",
//                               color: cs.onPrimary,
//                             ),

//                             SizedBox(width: sizer.w(8)),
//                             PlusJakartaSans(
//                               text: "(24)",
//                               color: cs.onPrimary,
//                               fontSize: sizer.w(16),
//                             ),

//                             SizedBox(width: sizer.w(8)),
//                             SvgPicture.asset(AppSvg.verify),
//                           ],
//                         ),

//                         SizedBox(height: sizer.h(8)),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(sizer.w(14)),
//                           child: BackdropFilter(
//                             filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: sizer.w(10),
//                                 vertical: sizer.h(6),
//                               ),
//                               decoration: BoxDecoration(
//                                 color: cs.onPrimary.withOpacity(0.16),
//                                 borderRadius: BorderRadius.circular(
//                                   sizer.w(14),
//                                 ),

//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.25),
//                                     blurRadius: 16,
//                                     offset: const Offset(0, 8),
//                                     spreadRadius: 0,
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Iconsax.location_bold,
//                                     color: cs.onPrimary,
//                                     size: sizer.w(17),
//                                   ),
//                                   SizedBox(width: sizer.w(8)),
//                                   AppText(
//                                      "5 km",
//                                     color: cs.onPrimary,
//                                     size: ,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     // right: small circular button
//                     Container(
//                       width: sizer.w(46),
//                       height: sizer.w(46),
//                       padding: EdgeInsets.all(sizer.w(9)),
//                       decoration: BoxDecoration(
//                         color: cs.onPrimary.withOpacity(0.12),
//                         shape: BoxShape.circle,
//                       ),
//                       child: SvgPicture.asset(AppSvg.upArrow),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (index == 2)
//               Positioned(
//                 right: 5,
//                 top: 20,
//                 child: SvgPicture.asset(AppSvg.superLike),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
