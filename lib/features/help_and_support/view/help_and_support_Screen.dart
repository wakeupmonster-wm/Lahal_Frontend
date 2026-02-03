// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../../utils/components/text/app_text.dart';
// import '../../../utils/constants/app_sizer.dart';
// import '../../../utils/routes/app_pages.dart';

// class HelpSupportScreen extends StatelessWidget {
//   const HelpSupportScreen({super.key});

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
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: InkWell(
//                       onTap: () => Navigator.of(context).maybePop(),
//                       child: Padding(
//                         padding: EdgeInsets.all(sizer.w(6)),
//                         child: Icon(Icons.arrow_back, size: sizer.w(22), color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: PlusJakartaSans(
//                       text: 'Help & Support',
//                       fontSize: sizer.w(18),
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: SizedBox(width: sizer.w(36)),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: sizer.h(26)),

//             // ---------- Menu Items ----------
//             _HelpTile(
//               sizer: sizer,
//               title: 'FAQ',
//               onTap: () {
//                 context.push(AppRoutes.faqScreen);
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Contact Support',
//               onTap: () {
//                 context.push(AppRoutes.contactSupportScreen);
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Terms & Conditions',
//               onTap: () {
//                 context.push(AppRoutes.termsConditionsScreen);
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Privacy Policy',
//               onTap: () {
//                 context.push(AppRoutes.privacyPolicyScreenHelp);
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Feedback',
//               onTap: () {
//                 // context.push(AppRoutes.feedbackScreen);
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'About us',
//               onTap: () {
//                 // context.push(AppRoutes.aboutUsScreen);
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Rate us',
//               onTap: () {
//                 // open store rating
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Visit Our Website',
//               onTap: () {
//                 // launch website
//               },
//             ),
//             _HelpTile(
//               sizer: sizer,
//               title: 'Follow us on Social Media',
//               onTap: () {
//                 // open social links
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HelpTile extends StatelessWidget {
//   final SizeConfig sizer;
//   final String title;
//   final VoidCallback onTap;

//   const _HelpTile({
//     required this.sizer,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final s = sizer;

//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: s.w(22), vertical: s.h(16)),
//         child: Row(
//           children: [
//             Expanded(
//               child: PlusJakartaSans(
//                 text: title,
//                 fontSize: s.w(16),
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               size: s.w(24),
//               color: Colors.black54,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
