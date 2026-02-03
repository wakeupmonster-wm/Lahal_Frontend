import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import this for SVG support

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the URL is an SVG (based on the file extension)
    if (imageUrl.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholderBuilder: (context) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height,
            width: width,
            color: Colors.grey[300],
          ),
        ),
        // Handle errors for SVG images
        // errorWidget: (context, url, error) =>
        //     Icon(
        //       Icons.error,
        //       color: Colors.grey,
        //     ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height,
            width: width,
            color: Colors.grey[300],
          ),
        ),
        errorWidget: (context, url, error) =>
            Icon(Icons.error, color: Colors.grey),
      );
    }
  }
}

// class CustomNetworkImage extends StatelessWidget {
//   final String imageUrl;
//   final double? height;
//   final double? width;
//   final BoxFit fit;
//
//   const CustomNetworkImage({
//     Key? key,
//     required this.imageUrl,
//      this.height,
//      this.width,
//     this.fit = BoxFit.cover,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       imageUrl: imageUrl,
//       height: height,
//       width: width,
//       fit: fit,
//       placeholder: (context, url) => Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           height: height,
//           width: width,
//           color: Colors.grey[300],
//         ),
//       ),
//       errorWidget: (context, url, error) => Icon(
//         Icons.error,
//         color: AppColor.greyTextColor,
//       ),
//     );
//   }
// }
