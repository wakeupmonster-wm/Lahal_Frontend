// import 'package:lahal_application/utils/components/buttons/customeElevatedButton.dart';
// import 'package:lahal_application/utils/components/text/app_text.dart';
// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:lahal_application/utils/constants/app_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class WarningDisplay extends StatelessWidget {
//   final String warningMessage;
//   final String subWarningMessage;
//   final double? boxHeight;
//   final String iconPath;

//   const WarningDisplay({
//     super.key,
//     this.warningMessage = 'No data available at the moment.',
//     this.subWarningMessage = 'Please check back later or try again..',
//     this.boxHeight,
//     this.iconPath = "assets/homePageIcons/data not found.svg",
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
//           SvgPicture.asset(iconPath, width: width * 0.15),
//           SizedBox(height: height * 0.015),
//           MyManropeText(
//             text: warningMessage,
//             fontWeight: FontWeight.w800,
//             fontSize: AppSizer.fontSize16,
//             maxLines: 3,
//           ),
//           SizedBox(height: height * 0.005),
//           MyManropeText(
//             text: subWarningMessage,
//             textAlign: TextAlign.center,
//             fontSize: AppSizer.fontSize12,
//             fontWeight: FontWeight.w600,
//             color: AppColor.greyTextColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
