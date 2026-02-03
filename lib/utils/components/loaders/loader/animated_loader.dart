// import 'package:lahal_application/utils/components/text/app_text.dart';
// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class AnimatedLoading extends StatelessWidget {
//   final String? text;
//   final double? boxHeight;
//   const AnimatedLoading({super.key, this.text, this.boxHeight});

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     return SizedBox(
//       height: boxHeight ?? height * 0.5,
//       width: width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: width * 0.16,
//             height: width * 0.16,
//             child: Lottie.asset("assets/json/loading.json"),
//           ),
//           SizedBox(height: height * 0.03),
//           MyManropeText(
//             text: text ?? "Loading...",
//             fontSize: AppSizer.fontSize13,
//             fontWeight: FontWeight.w700,
//             color: AppColor.primaryColor1.withOpacity(0.6),
//           ),
//         ],
//       ),
//     );
//   }
// }
