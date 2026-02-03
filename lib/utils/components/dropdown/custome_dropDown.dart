// import 'package:lahal_application/utils/components/text/app_text.dart';
// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/constants/app_sizer.dart';
// import 'package:flutter/material.dart';

// class CustomDropdown extends StatefulWidget {
//   final List<String> items;
//   final String selectedValue;
//   final ValueChanged<String> onSelected;

//   const CustomDropdown({
//     Key? key,
//     required this.items,
//     required this.selectedValue,
//     required this.onSelected,
//   }) : super(key: key);

//   @override
//   _CustomDropdownState createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   late OverlayEntry _overlayEntry;
//   bool isDropdownOpen = false;
//   late String selectedValue;

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
//         top: offset.dy + size.height - AppSizer.height * 0.004,
//         width: size.width,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: AppSizer.vertical1),
//             margin: EdgeInsets.symmetric(horizontal: AppSizer.horizontal15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: widget.items
//                   .map(
//                     (item) => GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedValue = item;
//                           widget.onSelected(item);
//                         });
//                         _closeDropdown();
//                       },
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: AppSizer.horizontal10,
//                           vertical: AppSizer.vertical6,
//                         ),
//                         child: MyManropeText(
//                           text: item,
//                           color: AppColor.primaryColor2,
//                           fontSize: AppSizer.fontSize12,
//                         ),
//                       ),
//                     ),
//                   )
//                   .toList(),
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
//     return GestureDetector(
//       onTap: _toggleDropdown,
//       child: Container(
//         width: AppSizer.width * 0.23,
//         height: AppSizer.height * 0.002,
//         padding: EdgeInsets.symmetric(horizontal: AppSizer.vertical1),
//         margin: EdgeInsets.symmetric(
//           horizontal: AppSizer.horizontal10,
//           vertical: AppSizer.height * 0.009,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.blue),
//           borderRadius: BorderRadius.circular(8.0),
//           color: Colors.white,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             MyManropeText(
//               text: selectedValue,
//               color: AppColor.primaryColor2,
//               fontSize: AppSizer.fontSize10,
//             ),
//             Icon(
//               Icons.keyboard_arrow_down,
//               color: AppColor.primaryColor2,
//               size: AppSizer.width * 0.05,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
