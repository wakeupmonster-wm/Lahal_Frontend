// import 'package:lahal_application/utils/components/text/app_text.dart';
// import 'package:flutter/material.dart';

// class CustomTextButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final IconData? icon;
//   final Color textColor;
//   final Color iconColor;
//   final double? textSize;
//   final double? iconSize;

//   const CustomTextButton({
//     super.key,
//     required this.onPressed,
//     required this.text,
//     this.icon,
//     this.textColor = Colors.black,
//     this.iconColor = Colors.black,
//     this.textSize,
//     this.iconSize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.sizeOf(context).width;
//     var height = MediaQuery.sizeOf(context).height;

//     return TextButton(
//       onPressed: onPressed,
//       style: TextButton.styleFrom(
//         padding: EdgeInsets.symmetric(
//           horizontal: width * 0.03,
//           vertical: height * 0.02,
//         ),
//         backgroundColor: Colors.transparent,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           MyManropeText(
//             text: text,
//             color: textColor,
//             fontSize: textSize ?? width * 0.04,
//             fontWeight: FontWeight.w600,
//           ),
//           SizedBox(width: width * 0.012),
//           icon != null
//               ? Icon(icon, color: iconColor, size: iconSize ?? width * 0.047)
//               : SizedBox(),
//         ],
//       ),
//     );
//   }
// }
