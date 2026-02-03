import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../shimmer/app_shimmer_effect.dart';

class AppCacheImage extends StatefulWidget {
  const AppCacheImage({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.width = 56,
    this.height = 56,
    this.fit = BoxFit.cover,
    this.onDoubleTap,
    this.errorWidget,
    this.isCircular = false,
    this.progressIndicatorWidget,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final double width;
  final double height;
  final VoidCallback? onDoubleTap;
  final Widget? errorWidget;
  final bool? isCircular;
  final Widget? progressIndicatorWidget;

  @override
  State<AppCacheImage> createState() => _AppCacheImageState();
}

class _AppCacheImageState extends State<AppCacheImage> {
  bool _hasError = false;

  void _setError() {
    if (!_hasError) {
      // Schedule the state update after the current frame to avoid the error.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTap ?? () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          widget.isCircular ?? false ? 100 : 0,
        ),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.isNetworkImage
              ? CachedNetworkImage(
                  height: widget.height,
                  fit: widget.fit,
                  color: widget.overlayColor,
                  imageUrl: widget.image,
                  filterQuality: FilterQuality.high,
                  progressIndicatorBuilder: (context, url, progress) {
                    return !_hasError
                        ? widget.progressIndicatorWidget ??
                              AppShimerEffect(
                                width: widget.width,
                                height: widget.height,
                                radius: 1,
                              )
                        : widget.errorWidget ?? const Icon(Icons.error);
                  },
                  errorWidget: (_, __, ___) {
                    _setError();
                    return widget.errorWidget ?? const Icon(Icons.error);
                  },
                )
              : const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}

// class AppCacheImage extends StatelessWidget {
//   const AppCacheImage({
//     super.key,
//     required this.image,
//     this.isNetworkImage = false,
//     this.overlayColor,
//     this.width = 56,
//     this.height = 56,
//     this.fit = BoxFit.cover,
//     this.onDoubleTap,
//     this.errorWidget,
//     this.isCircular = false,
//     this.progressIndicatorWidget,
//   });

//   final BoxFit? fit;
//   final String image;
//   final bool isNetworkImage;
//   final Color? overlayColor;
//   final double width;
//   final double height;
//   final VoidCallback? onDoubleTap;
//   final Widget? errorWidget;
//   final bool? isCircular;
//   final Widget? progressIndicatorWidget;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onDoubleTap: onDoubleTap ?? () {},
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(isCircular ?? false ? 100 : 0),
//         child: SizedBox(
//           width: width,
//           height: height,
//           child: isNetworkImage
//               ? CachedNetworkImage(
//                   height: height,
//                   fit: fit,
//                   color: overlayColor,
//                   imageUrl: image,
//                   filterQuality: FilterQuality.high,
//                   progressIndicatorBuilder: (context, url, progress) {
//                     return progressIndicatorWidget ??
//                         AppShimerEffect(
//                           width: width,
//                           height: height,
//                           radius: 1,
//                         );
//                   },
//                   errorListener: (value) => const Icon(Icons.error),
//                   errorWidget: (_, __, ___) =>
//                       errorWidget ?? const Icon(Icons.error),
//                 )
//               : ClipRRect(
//                   borderRadius:
//                       BorderRadius.circular(isCircular ?? false ? 100 : 0),
//                   child: SizedBox(
//                     width: width,
//                     height: height,
//                     child: const Center(
//                       child: Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
