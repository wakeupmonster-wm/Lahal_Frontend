// import 'package:mafs/utils/components/text/app_text.dart';
// import 'package:mafs/utils/constants/app_colors.dart';
// import 'package:mafs/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

// class SearchMealDropDown extends StatefulWidget {
//   final List<String> items;
//   final String? selectedValue; // Allow null to handle no initial value
//   final ValueChanged<String> onSelected;

//   const SearchMealDropDown({
//     super.key,
//     required this.items,
//     this.selectedValue,
//     required this.onSelected,
//   });

//   @override
//   _SearchMealDropDownState createState() => _SearchMealDropDownState();
// }

// class _SearchMealDropDownState extends State<SearchMealDropDown> {
//   final LayerLink _layerLink = LayerLink(); // LayerLink for positioning overlay
//   late OverlayEntry _overlayEntry;
//   bool isDropdownOpen = false;
//   late String? selectedValue;

//   @override
//   void initState() {
//     super.initState();
//     selectedValue = widget.selectedValue;
//   }

//   @override
//   void dispose() {
//     if (isDropdownOpen) {
//       _overlayEntry.remove();
//       isDropdownOpen = false;
//     }
//     super.dispose();
//   }

//   void _closeDropdown() {
//     if (isDropdownOpen) {
//       _overlayEntry.remove();
//       isDropdownOpen = false;
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);

//     return OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height - AppSizer.height * 0.0024,
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: const Offset(0, 30),
//           // Adjust the position of the dropdown if needed
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: AppRes.height * 0.01),
//               width: AppSizer.width * 0.28,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(AppSizer.width * 0.025),
//                   bottomRight: Radius.circular(AppSizer.width * 0.025),
//                 ),
//                 border: Border(
//                   bottom: BorderSide(
//                     width: 3,
//                     color: AppColor.cardBackGroundBlueColor,
//                   ),
//                   left: BorderSide(
//                     width: 3,
//                     color: AppColor.cardBackGroundBlueColor,
//                   ),
//                   right: BorderSide(
//                     width: 3,
//                     color: AppColor.cardBackGroundBlueColor,
//                   ),
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: widget.items
//                     .map(
//                       (item) => InkWell(
//                         onTap: () {
//                           setState(() {
//                             selectedValue = item;
//                             widget.onSelected(item);
//                           });
//                           _closeDropdown();
//                         },
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           padding: EdgeInsets.symmetric(
//                             vertical: AppRes.height * 0.005,
//                           ),
//                           child: Center(
//                             child: MyManropeText(
//                               text: item,
//                               color: const Color(0xFF006193),
//                               fontSize: AppSizer.fontSize12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleDropdown() {
//     if (isDropdownOpen) {
//       _closeDropdown();
//     } else {
//       _openDropdown();
//     }
//   }

//   void _openDropdown() {
//     _overlayEntry = _createOverlayEntry();
//     Overlay.of(context).insert(_overlayEntry);
//     setState(() {
//       isDropdownOpen = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Check if the value is selected
//     final isValueSelected = selectedValue != null && selectedValue!.isNotEmpty;

//     return GestureDetector(
//       onTap: _toggleDropdown,
//       child: CompositedTransformTarget(
//         link: _layerLink, // Link for positioning the dropdown
//         child: Container(
//           width: AppSizer.width * 0.28,
//           padding: EdgeInsets.symmetric(
//             horizontal: AppSizer.horizontal10,
//             vertical: AppSizer.vertical1,
//           ),
//           decoration: BoxDecoration(
//             border: isDropdownOpen ? Border.all(color: AppColor.cardBackGroundBlueColor) : null,
//             borderRadius: isDropdownOpen
//                 ? BorderRadius.only(
//                     topLeft: Radius.circular(AppSizer.width * 0.025),
//                     topRight: Radius.circular(AppSizer.width * 0.025),
//                   )
//                 : BorderRadius.circular(AppSizer.width * 0.025),
//             color: isValueSelected
//                 ? AppColor
//                       .primaryColor1 // Selected color
//                 : AppColor.cardBackGroundBlueColor,
//           ),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: AppSizer.width * 0.18,
//                   child: MyManropeText(
//                     text: isValueSelected ? "${selectedValue!.replaceAll(" ", "")} Added" : "Add to Meal",
//                     color: isValueSelected
//                         ? Colors
//                               .white // Adjust text color for better contrast
//                         : AppColor.primaryColor1,
//                     fontWeight: FontWeight.w900,
//                     fontSize: AppSizer.fontSize11,
//                     maxLines: 1,
//                   ),
//                 ),
//                 Icon(
//                   size: AppSizer.width * 0.045,
//                   isDropdownOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
//                   color: isValueSelected
//                       ? Colors
//                             .white // Adjust text color for better contrast
//                       : AppColor.primaryColor1,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class SearchMealDropDown extends StatefulWidget {
// //   final List<String> items;
// //   final String? selectedValue; // Allow null to handle no initial value
// //   final ValueChanged<String> onSelected;
// //
// //   const SearchMealDropDown({
// //     super.key,
// //     required this.items,
// //     this.selectedValue,
// //     required this.onSelected,
// //   });
// //
// //   @override
// //   _SearchMealDropDownState createState() => _SearchMealDropDownState();
// // }
// //
// // class _SearchMealDropDownState extends State<SearchMealDropDown> {
// //   final LayerLink _layerLink = LayerLink();
// //   OverlayEntry? _overlayEntry;
// //   bool isDropdownOpen = false;
// //   late String? selectedValue;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     selectedValue = widget.selectedValue;
// //   }
// //
// //   @override
// //   void dispose() {
// //     _closeDropdown();
// //     super.dispose();
// //   }
// //
// //   void _closeDropdown() {
// //     if (isDropdownOpen) {
// //       _overlayEntry?.remove();
// //       _overlayEntry = null;
// //       isDropdownOpen = false;
// //       setState(() {});
// //     }
// //   }
// //
// //   OverlayEntry _createOverlayEntry() {
// //     RenderBox renderBox = context.findRenderObject() as RenderBox;
// //     final size = renderBox.size;
// //
// //     return OverlayEntry(
// //       builder: (context) => Positioned(
// //         width: size.width,
// //         child: CompositedTransformFollower(
// //           link: _layerLink,
// //           showWhenUnlinked: false,
// //           offset: Offset(0, size.height + 4), // Adjust offset if needed
// //           child: Material(
// //             color: Colors.transparent,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(vertical: 10.0),
// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   bottomLeft: Radius.circular(8),
// //                   bottomRight: Radius.circular(8),
// //                 ),
// //                 border: Border(
// //                   bottom: BorderSide(
// //                     width: 3,
// //                     color: Colors.blue, // Adjust border color
// //                   ),
// //                   left: BorderSide(
// //                     width: 3,
// //                     color: Colors.blue, // Adjust border color
// //                   ),
// //                   right: BorderSide(
// //                     width: 3,
// //                     color: Colors.blue, // Adjust border color
// //                   ),
// //                 ),
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: widget.items
// //                     .map((item) => InkWell(
// //                   onTap: () {
// //                     setState(() {
// //                       selectedValue = item;
// //                       widget.onSelected(item);
// //                     });
// //                     _closeDropdown();
// //                   },
// //                   child: Container(
// //                     alignment: Alignment.centerLeft,
// //                     padding: const EdgeInsets.symmetric(vertical: 6.0),
// //                     child: Text(
// //                       item,
// //                       style: TextStyle(
// //                         color: const Color(0xFF006193),
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ),
// //                 ))
// //                     .toList(),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _toggleDropdown() {
// //     if (isDropdownOpen) {
// //       _closeDropdown();
// //     } else {
// //       _openDropdown();
// //     }
// //   }
// //
// //   void _openDropdown() {
// //     _overlayEntry = _createOverlayEntry();
// //     Overlay.of(context).insert(_overlayEntry!);
// //     setState(() {
// //       isDropdownOpen = true;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final isValueSelected = selectedValue != null && selectedValue!.isNotEmpty;
// //
// //     return GestureDetector(
// //       onTap: _toggleDropdown,
// //       child: CompositedTransformTarget(
// //         link: _layerLink,
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
// //           decoration: BoxDecoration(
// //             border: isDropdownOpen
// //                 ? Border.all(color: Colors.blue)
// //                 : null,
// //             borderRadius: isDropdownOpen
// //                 ? const BorderRadius.only(
// //               topLeft: Radius.circular(8),
// //               topRight: Radius.circular(8),
// //             )
// //                 : BorderRadius.circular(8.0),
// //             color: isValueSelected
// //                 ? Colors.blue
// //                 : Colors.grey,
// //           ),
// //           child: Center(
// //             child: Text(
// //               isValueSelected
// //                   ? "${selectedValue!.replaceAll(" ", "")} Added"
// //                   : "Add to Meal",
// //               style: TextStyle(
// //                 color: isValueSelected ? Colors.white : Colors.black,
// //                 fontWeight: FontWeight.w900,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class SearchMealDropDown extends StatefulWidget {
// //   final List<String> items;
// //   final String? selectedValue; // Allow null to handle no initial value
// //   final ValueChanged<String> onSelected;
// //
// //
// //   const SearchMealDropDown({
// //     super.key,
// //     required this.items,
// //     this.selectedValue,
// //     required this.onSelected,
// //   });
// //
// //   @override
// //   _SearchMealDropDownState createState() => _SearchMealDropDownState();
// // }
// //
// // class _SearchMealDropDownState extends State<SearchMealDropDown> {
// //   late OverlayEntry _overlayEntry;
// //   bool isDropdownOpen = false;
// //   late String? selectedValue;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     selectedValue = widget.selectedValue;
// //   }
// //
// //   @override
// //   void dispose() {
// //     if (isDropdownOpen) {
// //       _overlayEntry.remove();
// //       isDropdownOpen = false;
// //     }
// //     super.dispose();
// //   }
// //
// //   void _closeDropdown() {
// //     if (isDropdownOpen) {
// //       _overlayEntry.remove();
// //       isDropdownOpen = false;
// //       if (mounted) {
// //         setState(() {});
// //       }
// //     }
// //   }
// //
// //   OverlayEntry _createOverlayEntry() {
// //     RenderBox renderBox = context.findRenderObject() as RenderBox;
// //     var size = renderBox.size;
// //     var offset = renderBox.localToGlobal(Offset.zero);
// //
// //     return OverlayEntry(
// //       builder: (context) => Positioned(
// //         left: offset.dx,
// //         top: offset.dy + size.height - AppSizer.height * 0.0024,
// //         width: size.width,
// //         child: Material(
// //           color: Colors.transparent,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// //             width: AppSizer.width * 0.28,
// //             decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   bottomLeft: Radius.circular(8),
// //                   bottomRight: Radius.circular(8),
// //                 ),
// //                 border: Border(
// //                   bottom: BorderSide(
// //                     width: 3,
// //                     color: AppColor.cardBackGroundBlueColor,
// //                   ),
// //                   left: BorderSide(
// //                     width: 3,
// //                     color: AppColor.cardBackGroundBlueColor,
// //                   ),
// //                   right: BorderSide(
// //                     width: 3,
// //                     color: AppColor.cardBackGroundBlueColor,
// //                   ),
// //                 )),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: widget.items
// //                   .map((item) => InkWell(
// //                         onTap: () {
// //                           setState(() {
// //                             selectedValue = item;
// //                             widget.onSelected(item);
// //                           });
// //                           _closeDropdown();
// //                         },
// //                         child: Container(
// //                           alignment: Alignment.centerLeft,
// //                           padding: const EdgeInsets.symmetric(vertical: 6.0),
// //                           child: Center(
// //                             child: MyManropeText(
// //                               text: item,
// //                               color: const Color(0xFF006193),
// //                               fontSize: AppSizer.fontSize12,
// //                             ),
// //                           ),
// //                         ),
// //                       ))
// //                   .toList(),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _toggleDropdown() {
// //     if (isDropdownOpen) {
// //       _closeDropdown();
// //     } else {
// //       _openDropdown();
// //     }
// //   }
// //
// //   void _openDropdown() {
// //     _overlayEntry = _createOverlayEntry();
// //     Overlay.of(context).insert(_overlayEntry);
// //     setState(() {
// //       isDropdownOpen = true;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // final isValueSelected = selectedValue != null || selectedValue!.isNotEmpty;
// //     final isValueSelected = selectedValue != null && selectedValue!.isNotEmpty;
// //
// //     return GestureDetector(
// //       onTap: _toggleDropdown,
// //       child: Container(
// //         width: AppSizer.width * 0.28,
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
// //         decoration: BoxDecoration(
// //           border: isDropdownOpen
// //               ? Border.all(color: AppColor.cardBackGroundBlueColor)
// //               : null,
// //           borderRadius: isDropdownOpen
// //               ? const BorderRadius.only(
// //                   topLeft: Radius.circular(8),
// //                   topRight: Radius.circular(8),
// //                 )
// //               : BorderRadius.circular(8.0),
// //           color: isValueSelected
// //               ? AppColor
// //                   .primaryColor1 // Change this to the desired color for selected
// //               : AppColor.cardBackGroundBlueColor,
// //         ),
// //         child: Center(
// //           child: MyManropeText(
// //             text: isValueSelected
// //                 ? "${selectedValue!.replaceAll(" ", "")} Added"
// //                 : "Add to Meal",
// //             color: isValueSelected
// //                 ? Colors.white // Adjust text color for better contrast
// //                 : AppColor.primaryColor1,
// //             fontWeight: FontWeight.w900,
// //             fontSize: AppSizer.fontSize12,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
