// import 'package:flutter/material.dart';

// import '../../../utils/components/text/app_text.dart';
// import '../../../utils/constants/app_sizer.dart';

// class PrivacyPolicyScreenHelp extends StatelessWidget {
//   const PrivacyPolicyScreenHelp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sizer = SizeConfig(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
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
//                       text: 'Privacy Policy',
//                       fontSize: sizer.w(18),
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: sizer.h(18)),

//             // ---------- Content ----------
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: sizer.w(20),
//                   vertical: sizer.h(6),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _title(sizer, '1. Data Collection'),
//                     _bullet(
//                       sizer,
//                       'Match At First Swipe collects user data, including personal information, to provide and improve our services.',
//                     ),
//                     _bullet(
//                       sizer,
//                       'Information collected may include profile data, location, and usage patterns.',
//                     ),

//                     _title(sizer, '2. Data Use'),
//                     _bullet(
//                       sizer,
//                       'We use data to facilitate matching, communication, and personalization of the app.',
//                     ),
//                     _bullet(
//                       sizer,
//                       'Your data may be shared with third-party service providers for app functionality.',
//                     ),

//                     _title(sizer, '3. Data Protection'),
//                     _paragraph(
//                       sizer,
//                       'Match At First Swipe employs security measures to protect user data. However, no system is entirely foolproof, and we cannot guarantee absolute security.',
//                     ),

//                     _title(sizer, '4. Cookies and Analytics'),
//                     _paragraph(
//                       sizer,
//                       'We use cookies and analytics tools to gather information about app usage, improve our services, and deliver targeted content.',
//                     ),

//                     _title(sizer, '5. Third-Party Links'),
//                     _paragraph(
//                       sizer,
//                       'Match At First Swipe may contain links to third-party websites or services. We are not responsible for their privacy practices.',
//                     ),

//                     _title(sizer, '6. Data Retention'),
//                     _bullet(
//                       sizer,
//                       'We retain user data as long as necessary for app functionality or as required by law.',
//                     ),
//                     _bullet(
//                       sizer,
//                       'Users can request data deletion through the app settings.',
//                     ),

//                     _title(sizer, '7. Communication'),
//                     _paragraph(
//                       sizer,
//                       'By using Match At First Swipe, you consent to receive app-related communications, including notifications and updates.',
//                     ),

//                     _title(sizer, "8. Children's Privacy"),
//                     _paragraph(
//                       sizer,
//                       'Match At First Swipe is not intended for users under 18. We do not knowingly collect data from children.',
//                     ),

//                     _title(sizer, '9. Changes to Privacy Policy'),
//                     _paragraph(
//                       sizer,
//                       'Match At First Swipe may update the Privacy Policy. Users will be notified of changes, and continued use implies acceptance.',
//                     ),

//                     SizedBox(height: sizer.h(40)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------- Helpers ----------

//   Widget _title(SizeConfig sizer, String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: sizer.h(6)),
//       child: PlusJakartaSans(
//         text: text,
//         fontSize: sizer.w(15),
//         fontWeight: FontWeight.w700,
//         color: Colors.black87,
//       ),
//     );
//   }

//   Widget _paragraph(SizeConfig sizer, String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: sizer.h(18)),
//       child: PlusJakartaSans(
//         text: text,
//         fontSize: sizer.w(14),
//         height: 1.5,
//         fontWeight: FontWeight.w400,
//         color: Colors.grey[800],
//       ),
//     );
//   }

//   Widget _bullet(SizeConfig sizer, String text) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: sizer.w(8),
//         bottom: sizer.h(10),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: sizer.h(6)),
//             child: Container(
//               width: sizer.w(4),
//               height: sizer.w(4),
//               decoration: const BoxDecoration(
//                 color: Colors.black87,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           SizedBox(width: sizer.w(10)),
//           Expanded(
//             child: PlusJakartaSans(
//               text: text,
//               fontSize: sizer.w(14),
//               height: 1.5,
//               fontWeight: FontWeight.w400,
//               color: Colors.grey[800],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
