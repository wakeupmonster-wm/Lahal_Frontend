// import 'package:flutter/material.dart';

// import '../../../utils/components/text/app_text.dart';
// import '../../../utils/constants/app_sizer.dart';

// class ContactSupportScreen extends StatelessWidget {
//   const ContactSupportScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sizer = SizeConfig(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: sizer.h(12)),

//             // ---------- Top Bar ----------
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: sizer.w(18),
//                         color: Colors.black87,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                   Center(
//                     child: PlusJakartaSans(
//                       text: 'Contact Support',
//                       fontSize: sizer.w(18),
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: sizer.h(26)),

//             // ---------- Support Options ----------
//             _SupportTile(
//               sizer: sizer,
//               icon: Icons.headset_mic_outlined,
//               title: 'Customer Support',
//               onTap: () {
//                 // open customer support
//               },
//             ),
//             _SupportTile(
//               sizer: sizer,
//               icon: Icons.language_outlined,
//               title: 'Website',
//               onTap: () {
//                 // open website
//               },
//             ),
//             _SupportTile(
//               sizer: sizer,
//               icon: Icons.whatshot,
//               title: 'WhatsApp',
//               onTap: () {
//                 // open whatsapp
//               },
//             ),
//             _SupportTile(
//               sizer: sizer,
//               icon: Icons.facebook,
//               title: 'Facebook',
//               onTap: () {
//                 // open facebook
//               },
//             ),
//             _SupportTile(
//               sizer: sizer,
//               icon: Icons.alternate_email,
//               title: 'Twitter',
//               onTap: () {
//                 // open twitter
//               },
//             ),
//             _SupportTile(
//               sizer: sizer,
//               icon: Icons.camera_alt_outlined,
//               title: 'Instagram',
//               onTap: () {
//                 // open instagram
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class _SupportTile extends StatelessWidget {
//   final SizeConfig sizer;
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const _SupportTile({
//     required this.sizer,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final s = sizer;

//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(
//           horizontal: s.w(20),
//           vertical: s.h(8),
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: s.w(16),
//           vertical: s.h(18),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(s.w(14)),
//           border: Border.all(
//             color: Colors.grey.withOpacity(0.2),
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: s.w(36),
//               height: s.w(36),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2FB6B3).withOpacity(0.12),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 color: const Color(0xFF2FB6B3),
//                 size: s.w(18),
//               ),
//             ),
//             SizedBox(width: s.w(14)),
//             Expanded(
//               child: PlusJakartaSans(
//                 text: title,
//                 fontSize: s.w(15),
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
