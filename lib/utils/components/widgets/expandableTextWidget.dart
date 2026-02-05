// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ExpandableText extends StatefulWidget {
//   final String description;
//   final int maxLength;
//   final double? fontSize;
//   final Color? color;
//   final double? height;
//   final FontWeight? fontWeight;

//   const ExpandableText({
//     super.key,
//     required this.description,
//     this.maxLength = 120,
//     this.fontSize,
//     this.color,
//     this.height,
//     this.fontWeight, // Default length for truncation
//   });

//   @override
//   _ExpandableTextState createState() => _ExpandableTextState();
// }

// class _ExpandableTextState extends State<ExpandableText> {
//   bool isExpanded = false;

//   // Helper function to count words in the description
//   int _wordCount(String text) {
//     return text.split(RegExp(r'\s+')).length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.sizeOf(context).width;
//     var height = MediaQuery.sizeOf(context).height;

//     bool showToggle = _wordCount(widget.description) > 18;

//     return SizedBox(
//       width: width * 0.9,
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: isExpanded
//                   ? widget.description
//                   : widget.description.substring(
//                       0,
//                       widget.description.length > widget.maxLength
//                           ? widget.maxLength
//                           : widget.description.length,
//                     ),
//               style: GoogleFonts.manrope(
//                 color: widget.color ?? AppColor.greyTextColor,
//                 height: widget.height ?? height * 0.00156,
//                 fontWeight: widget.fontWeight ?? FontWeight.w600,
//                 fontSize: widget.fontSize ?? AppSizer.fontSize13,
//               ),
//             ),
//             if (showToggle) // Only add the "View more" / "Show less" button if words > 50
//               WidgetSpan(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isExpanded = !isExpanded;
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 4.0, top: 2),
//                     child: Text(
//                       isExpanded ? " Show less" : " View more",
//                       style: GoogleFonts.manrope(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.w900,
//                         fontSize: AppSizer.fontSize12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         maxLines: isExpanded ? 1000 : 3,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
// }

// // class ExpandableText extends StatefulWidget {
// //   final String description;
// //   final int maxLength;
// //
// //   const ExpandableText({
// //     Key? key,
// //     required this.description,
// //     this.maxLength = 120, // Default length for truncation
// //   }) : super(key: key);
// //
// //   @override
// //   _ExpandableTextState createState() => _ExpandableTextState();
// // }
// //
// // class _ExpandableTextState extends State<ExpandableText> {
// //   bool isExpanded = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     var width = MediaQuery.sizeOf(context).width;
// //     var height = MediaQuery.sizeOf(context).height;
// //     return SizedBox(
// //       width: width * 0.9,
// //       child: RichText(
// //         text: TextSpan(
// //           children: [
// //             TextSpan(
// //               text: isExpanded
// //                   ? widget.description
// //                   : '${widget.description.substring(0, widget.description.length > widget.maxLength ? widget.maxLength : widget.description.length)}...',
// //               style: GoogleFonts.manrope(
// //                 color: AppColor.greyTextColor,
// //                 height: height * 0.00156,
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: AppSizer.fontSize13,
// //               ),
// //             ),
// //             WidgetSpan(
// //               child: GestureDetector(
// //                 onTap: () {
// //                   setState(() {
// //                     isExpanded = !isExpanded;
// //                   });
// //                 },
// //                 child: Padding(
// //                   padding: const EdgeInsets.only(left: 4.0, top: 2),
// //                   child: Text(
// //                     isExpanded ? " Show less" : " View more",
// //                     style: GoogleFonts.manrope(
// //                       color: Colors.blue,
// //                       fontWeight: FontWeight.w900,
// //                       fontSize: AppSizer.fontSize12,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         maxLines: isExpanded ? 1000 : 3,
// //         overflow: TextOverflow.ellipsis,
// //       ),
// //     );
// //   }
// // }
