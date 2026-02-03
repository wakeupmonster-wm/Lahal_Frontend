// import 'package:lahal_application/utils/components/buttons/customeElevatedButton.dart';
// import 'package:lahal_application/utils/components/text/app_text.dart';
// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class ErrorDisplay extends StatelessWidget {
//   final VoidCallback onTap;
//   final String errorMessage;
//   final double? boxHeight;

//   const ErrorDisplay({
//     super.key,
//     required this.onTap,
//     required this.errorMessage,
//     this.boxHeight,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;

//     return SizedBox(
//       width: width,
//       height: boxHeight ?? height * 0.6,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             'assets/homePageIcons/error (1).svg',
//             width: width * 0.15,
//           ),
//           SizedBox(height: height * 0.005),
//           MyManropeText(
//             text: 'Oops! Something Went Wrong.',
//             fontWeight: FontWeight.w800,
//             fontSize: AppSizer.fontSize16,
//           ),
//           if (errorMessage != "") ...[
//             SizedBox(height: height * 0.005),
//             SizedBox(
//               width: width * 0.6,
//               child: MyManropeText(
//                 text: errorMessage,
//                 textAlign: TextAlign.center,
//                 fontSize: AppSizer.fontSize11,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.greyTextColor,
//                 maxLines: 3,
//               ),
//             ),
//           ],
//           SizedBox(height: height * 0.02),
//           SizedBox(
//             height: height * 0.04,
//             child: CustomeButton(
//               text: "Retry".toUpperCase(),
//               colour: AppColor.primaryColor4,
//               textColour: AppColor.primaryColor1,
//               onPressed: onTap,
//               horizontalPadding: width * 0.05,
//               verticalPadding: height * 0.00,
//               transparent: true,
//               borderRadius: width * 0.012,
//               borderWidth: width * 0.002,
//               textSize: AppSizer.fontSize10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
