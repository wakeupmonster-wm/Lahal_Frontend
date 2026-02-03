import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StackLaoding extends StatelessWidget {
  final bool isLoading;
  final Color? bgColor, loaderColor;
  const StackLaoding({
    super.key,
    required this.isLoading,
    this.bgColor,
    this.loaderColor,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return isLoading
        ? Container(
            width: width,
            height: height,
            color: bgColor ?? Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                color: loaderColor ?? AppColor.primaryColor1,
                strokeWidth: width * 0.0025,
              ),
            ),
          )
        : const SizedBox();
  }
}
