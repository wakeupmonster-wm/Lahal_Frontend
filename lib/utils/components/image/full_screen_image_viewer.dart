// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class FullScreenImageView extends StatefulWidget {
//   final List images;
//   final int currentIndex;

//   const FullScreenImageView({
//     super.key,
//     required this.images,
//     required this.currentIndex,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _FullScreenImageViewState createState() => _FullScreenImageViewState();
// }

// class _FullScreenImageViewState extends State<FullScreenImageView> {
//   int activeIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     activeIndex = widget.currentIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: CarouselSlider.builder(
//         options: CarouselOptions(
//           height: double.infinity,
//           viewportFraction: 1,
//           initialPage: widget.currentIndex,
//           enableInfiniteScroll: false,
//           onPageChanged: (index, reason) {
//             setState(() {
//               activeIndex = index;
//             });
//           },
//         ),
//         itemCount: widget.images.length,
//         itemBuilder: (context, index, realIndex) {
//           final image = widget.images[index];
//           return InteractiveViewer(
//             // boundary of image
//             boundaryMargin: const EdgeInsets.all(50),
//             minScale: 0.05,
//             maxScale: 10,
//             child: CachedNetworkImage(
//               imageUrl: image,
//               fit: BoxFit.contain,
//               errorListener: (value) => const Icon(Icons.error),
//               errorWidget: (_, __, ___) => Image.asset(""),
//               placeholder: (context, url) => const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColor.white,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: widget.images.length != 1
//           ? Container(
//               color: AppColor.white.withOpacity(0.3),
//               margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//               child: MyTextNotoSans(
//                 text: "${activeIndex + 1}/${widget.images.length}",
//                 color: AppColor.white,
//                 fontWeight: FontWeight.w600,
//                 textAlign: TextAlign.center,
//               ),
//             )
//           : const SizedBox(),
//     );
//   }
// }
