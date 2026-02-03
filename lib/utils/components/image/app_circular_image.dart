import 'package:cached_network_image/cached_network_image.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';

import '../shimmer/app_shimmer_effect.dart';

class AppCircularImage extends StatelessWidget {
  const AppCircularImage({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.fit = BoxFit.cover,
    this.assestImage,
    this.placeholder,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width;
  final double height;
  final String? assestImage;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      width: w * 0.24,
      height: w * 0.24,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  imageUrl: image,
                  width: w * 0.24,
                  height: w * 0.24,
                  progressIndicatorBuilder: (context, url, progress) =>
                      AppShimerEffect(
                        width: w * 0.24,
                        height: h * 0.12,
                        radius: 200,
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : placeholder ??
                    Image(
                      fit: fit,
                      image: AssetImage(assestImage ?? ""),
                      color: overlayColor,
                    ),
        ),
      ),
    );
  }
}
