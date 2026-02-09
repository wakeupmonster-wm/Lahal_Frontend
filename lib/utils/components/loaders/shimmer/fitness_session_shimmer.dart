// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class FitnessSessionShimmer extends StatelessWidget {
//   const FitnessSessionShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Column(
//       children: [
//         Shimmer.fromColors(
//           baseColor: Colors.grey.withOpacity(0.3),
//           highlightColor: Colors.grey.withOpacity(0.1),
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Container(color: Colors.grey.withOpacity(0.5), width: width),
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 10.0,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: height * 0.01),
//                   // Shimmer for Heading and Time
//                   Row(
//                     children: [
//                       _shimmerBox(width: width * 0.4, height: height * 0.03),
//                       const Spacer(),
//                       Row(
//                         children: [
//                           _shimmerBox(
//                             width: width * 0.042,
//                             height: width * 0.042,
//                             shape: BoxShape.circle,
//                           ),
//                           SizedBox(width: width * 0.012),
//                           _shimmerBox(
//                             width: width * 0.2,
//                             height: height * 0.02,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: height * 0.02),
//                   // Shimmer for Description
//                   _shimmerBox(width: double.infinity, height: height * 0.1),
//                   SizedBox(height: height * 0.02),
//                   Divider(color: Colors.grey.withOpacity(0.5), thickness: 1.8),
//                   SizedBox(height: height * 0.02),
//                   // Shimmer for Steps Heading
//                   _shimmerBox(width: width * 0.4, height: height * 0.03),
//                   SizedBox(height: height * 0.03),
//                   // Shimmer for Steps List
//                   ListView.builder(
//                     itemCount: 3, // Placeholder count for shimmer
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return _buildSectionShimmer(height, width);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionShimmer(double height, double width) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _shimmerBox(
//               width: width * 0.1,
//               height: height * 0.05,
//               shape: BoxShape.circle,
//             ),
//             SizedBox(width: width * 0.04),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _shimmerBox(width: width * 0.6, height: height * 0.02),
//                 SizedBox(height: height * 0.01),
//                 _shimmerBox(width: width * 0.5, height: height * 0.015),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: height * 0.02),
//       ],
//     );
//   }

//   Widget _shimmerBox({
//     required double width,
//     required double height,
//     BoxShape shape = BoxShape.rectangle,
//   }) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.withOpacity(0.3),
//       highlightColor: Colors.grey.withOpacity(0.1),
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.5),
//           shape: shape,
//           borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(8.0) : null,
//         ),
//       ),
//     );
//   }
// }
