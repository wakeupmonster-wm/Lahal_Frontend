// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/components/text/app_text.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:lahal_application/utils/theme/text/app_text.dart';
// import 'package:lahal_application/utils/theme/text/app_typography.dart';

// class CustomeButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final double horizontalPadding;
//   final double verticalPadding;
//   final Color colour;
//   final Color textColour;
//   final Color? borderColor;
//   final bool transparent;
//   final double? borderRadius;
//   final double? borderWidth;
//   final Icon? icon; // Optional icon parameter
//   final double? textSize; // Optional text size parameter

//   const CustomeButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.horizontalPadding = 70.0,
//     this.verticalPadding = 12.0,
//     Color? colour,
//     Color? textColour,
//     this.borderColor,
//     this.transparent = false,
//     this.borderRadius, // Optional user-defined border radius
//     this.borderWidth, // Optional user-defined border width
//     this.icon, // Optional icon
//     this.textSize, // Optional text size
//   }) : colour = colour ?? AppColor.primaryColor1,
//        textColour = textColour ?? Colors.white;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final defaultBorderRadius = size.width * 0.02;
//     const defaultBorderWidth = 2.0;
//     final defaultTextSize = size.width * 0.035; // Default text size

//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: colour,
//         elevation: 0,
//         shadowColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(
//             borderRadius ?? defaultBorderRadius, // Use user-defined or default
//           ),
//           side: BorderSide(
//             color: borderColor != null ? borderColor! : AppColor.primaryColor1,
//             width:
//                 borderWidth ??
//                 defaultBorderWidth, // Use user-defined or default
//           ),
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: horizontalPadding,
//           vertical: verticalPadding,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AppText(
//             text,
//             size: AppTextSize.s16,
//             weight: AppTextWeight.bold,
//             color: textColour,
//           ),
//           if (icon != null) ...[
//             SizedBox(width: 8.0), // Spacing between text and icon
//             icon!,
//           ],
//         ],
//       ),
//     );
//   }
// }

// class CustomeLogOutButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final double horizontalPadding;
//   final double verticalPadding;
//   final Color colour;
//   final Color textColour;
//   final bool transparent;
//   final double? borderRadius;
//   final double? borderWidth;
//   final Widget? icon; // Optional icon parameter
//   final double? textSize; // Optional text size parameter

//   const CustomeLogOutButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.horizontalPadding = 70.0,
//     this.verticalPadding = 12.0,
//     Color? colour,
//     Color? textColour,
//     this.transparent = false,
//     this.borderRadius, // Optional user-defined border radius
//     this.borderWidth, // Optional user-defined border width
//     this.icon, // Optional icon
//     this.textSize, // Optional text size
//   }) : colour = colour ?? AppColor.white,
//        textColour = textColour ?? AppColor.logOutRed;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final defaultBorderRadius = size.width * 0.027;
//     final defaultBorderWidth = 1.5;
//     final defaultTextSize = size.width * 0.038;
//     // Default text size

//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: colour,
//         elevation: 0,
//         shadowColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(
//             borderRadius ?? defaultBorderRadius, // Use user-defined or default
//           ),
//           side: BorderSide(
//             color: AppColor.logOutRed,

//             width:
//                 borderWidth ??
//                 defaultBorderWidth, // Use user-defined or default
//           ),
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: horizontalPadding,
//           vertical: verticalPadding,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null) ...[icon!, SizedBox(width: AppSizer.width * 0.03)],
//           PlusJakartaSans(
//             text: text,
//             fontSize: textSize ?? defaultTextSize,
//             // Use user-defined or default text size
//             color: textColour,
//             fontWeight: FontWeight.w800,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:mafs/utils/constants/colors.dart';
// // import 'package:mafs/utils/customeText/myText.dart';
// // import 'package:flutter/material.dart';
// // class CustomeButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback onPressed;
// //   double? horizontalPadding;
// //   double? verticalPadding;
// //   Color? colour;
// //   Color? textColour;
// //   bool transparent;
// //   CustomeButton({super.key, required this.text, required this.onPressed, this.horizontalPadding,   this.verticalPadding,
// //         this.colour,
// //         this.textColour,
// //       this.transparent = false});
// //   @override
// //   Widget build(BuildContext context) {
// //     final heights = MediaQuery.sizeOf(context).height;
// //     final width = MediaQuery.sizeOf(context).width;
// //     return ElevatedButton(
// //         onPressed: onPressed,
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: transparent?Colors.transparent:colour ??  AppColor.primaryColor1,
// //           elevation: 0, // Remove elevation to avoid shadow
// //           shadowColor: Colors.transparent, // Remove shadow color// Background color
// //           // foregroundColor: Colors.white, // Text color
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(width * 0.1),
// //             side: BorderSide(color: colour??AppColor.primaryColor1, width: 2.0),
// //           ),
// //           padding: EdgeInsets.symmetric(
// //               horizontal: horizontalPadding ?? width * 0.1,
// //               vertical:verticalPadding?? heights * 0.036), // Padding inside the button
// //         ),
// //
// //      child:    MyManropeText(
// //           text: text,
// //           fontSize: width * 0.035,
// //           color: transparent?AppColor.primaryColor1:textColour??Colors.white,
// //           fontWeight: FontWeight.w600,
// //         )
// //     );
// //   }
// // }

// // class CustomeButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback onPressed;
// //   final double horizontalPadding;
// //   final double verticalPadding;
// //   final Color colour;
// //   final Color textColour;
// //   final bool transparent;
// //   final double? borderRadius;
// //   final double? borderWidth;
// //   final Icon? icon; // Optional icon parameter
// //   final double? textSize; // Optional text size parameter
// //   final bool? isLoading; // Add a loading state

// //   const CustomeButton({
// //     super.key,
// //     required this.text,
// //     required this.onPressed,
// //     this.horizontalPadding = 70.0,
// //     this.verticalPadding = 12.0,
// //     Color? colour,
// //     Color? textColour,
// //     this.transparent = false,
// //     this.borderRadius, // Optional user-defined border radius
// //     this.borderWidth, // Optional user-defined border width
// //     this.icon, // Optional icon
// //     this.textSize,
// //     this.isLoading = false,
// //   })  : colour = colour ?? AppColor.primaryColor1,
// //         textColour = textColour ?? Colors.white;

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final defaultBorderRadius = size.width * 0.027;
// //     final defaultBorderWidth = 2.0;
// //     final defaultTextSize = size.width * 0.035; // Default text size

// //     return ElevatedButton(
// //       onPressed: !isLoading! ? null : onPressed,
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: colour,
// //         elevation: 0,
// //         shadowColor: Colors.transparent,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(
// //             borderRadius ?? defaultBorderRadius, // Use user-defined or default
// //           ),
// //           side: BorderSide(
// //             color: AppColor.primaryColor1,
// //             width: borderWidth ??
// //                 defaultBorderWidth, // Use user-defined or default
// //           ),
// //         ),
// //         padding: EdgeInsets.symmetric(
// //           horizontal: horizontalPadding,
// //           vertical: verticalPadding,
// //         ),
// //       ),
// //       child: isLoading!
// //           ? Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Center(
// //                   child: SizedBox(
// //                     height: size.width * 0.05,
// //                     width: size.width * 0.05,
// //                     child: const CircularProgressIndicator(
// //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             )
// //           : Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 MyManropeText(
// //                   text: text,
// //                   fontSize: textSize ?? defaultTextSize,
// //                   // Use user-defined or default text size
// //                   color: textColour,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //                 if (icon != null) ...[
// //                   const SizedBox(width: 8.0), // Spacing between text and icon
// //                   icon!,
// //                 ],
// //               ],
// //             ),
// //     );
// //   }
// // }
