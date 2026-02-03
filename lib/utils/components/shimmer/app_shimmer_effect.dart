import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimerEffect extends StatelessWidget {
  final double width, height, radius;
  final Color? color;
  const AppShimerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[400]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? AppColor.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
