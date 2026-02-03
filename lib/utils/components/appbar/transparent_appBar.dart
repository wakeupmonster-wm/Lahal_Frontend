// import 'package:mafs/utils/constants/app_colors.dart';
// import 'package:flutter/material.dart';

// class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final VoidCallback? onTap;
//   const TransparentAppBar({super.key, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//     return AppBar(
//       backgroundColor: AppColor.appBackgroundColor,
//       surfaceTintColor: Colors.transparent,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios_new, size: width * 0.045),
//         onPressed: onTap ?? () => Navigator.pop(context),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
