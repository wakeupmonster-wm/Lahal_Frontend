// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:lahal_application/utils/theme/text/app_text_color.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UrbanistText extends StatelessWidget {
//   final String text;
//   final double? fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//   final double? height;
//   final int? maxLines;
//   final TextAlign? textAlign;
//   final TextDecoration? textDecoration;

//   const UrbanistText({
//     super.key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.height,
//     this.maxLines,
//     this.textAlign,
//     this.textDecoration,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final heights = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     final tx = Theme.of(context).extension<AppTextColors>();
//     return Text(
//       text,
//       style: GoogleFonts.urbanist(
//         fontSize: fontSize ?? width * 0.065,
//         fontWeight: fontWeight ?? FontWeight.w700,
//         fontStyle: FontStyle.normal,
//         color: color ?? tx?.primary ?? AppColor.primaryColor1,
//         height: height ?? (heights > 650 ? heights / 600 : heights / 600),
//         decoration: textDecoration ?? TextDecoration.none,
//       ),
//       textAlign: textAlign ?? TextAlign.start,
//       maxLines: maxLines ?? 2,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }

// class PlusJakartaSans extends StatelessWidget {
//   final String text;
//   final double? fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//   final double? height;
//   final int? maxLines;
//   final TextAlign? textAlign;
//   final TextDecoration? textDecoration;

//   const PlusJakartaSans({
//     super.key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.height,
//     this.maxLines,
//     this.textAlign,
//     this.textDecoration,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final heights = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     final tx = Theme.of(context).extension<AppTextColors>();
//     return Text(
//       text,
//       style: GoogleFonts.plusJakartaSans(
//         fontSize: fontSize ?? width * 0.065,
//         fontWeight: fontWeight ?? FontWeight.w700,
//         fontStyle: FontStyle.normal,
//         color: color ?? tx?.primary ?? AppColor.primaryColor1,
//         height: height ?? (heights > 650 ? heights / 600 : heights / 600),
//         decoration: textDecoration ?? TextDecoration.none,
//       ),
//       textAlign: textAlign ?? TextAlign.start,
//       maxLines: maxLines ?? 2,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }

// class MyManropeText extends StatelessWidget {
//   final String text;
//   final double? fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//   final double? height;
//   final int? maxLines;
//   final TextAlign? textAlign;
//   final TextDecoration? textDecoration;
//   final Color? decorationColor;

//   const MyManropeText({
//     super.key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.height,
//     this.maxLines,
//     this.textAlign,
//     this.textDecoration,
//     this.decorationColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final heights = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     return Text(
//       text,
//       style: GoogleFonts.manrope(
//         fontSize: fontSize ?? AppSizer.fontSize13,
//         fontWeight: fontWeight ?? FontWeight.w700,
//         fontStyle: FontStyle.normal,
//         color: color ?? AppColor.primaryColor1,
//         height: height ?? (heights > 650 ? heights / 600 : heights / 600),
//         decoration: textDecoration ?? TextDecoration.none,
//         decorationColor: decorationColor,
//         decorationThickness: width * 0.008,
//       ),
//       textAlign: textAlign ?? TextAlign.start,
//       maxLines: maxLines ?? 5,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }
