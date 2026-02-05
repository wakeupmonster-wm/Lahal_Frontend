// import 'package:flutter/material.dart';

// import '../../../utils/components/text/app_text.dart';
// import '../../../utils/constants/app_sizer.dart';

// class TermsConditionsScreen extends StatelessWidget {
//   const TermsConditionsScreen({super.key});

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
//                       text: 'Terms & Conditions',
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
//                     _title(sizer, '1. Acceptance of Terms'),
//                     _paragraph(
//                       sizer,
//                       'By using the Match At First Swipe app, you agree to abide by these Terms & Conditions. If you do not agree, please refrain from using the app.',
//                     ),

//                     _title(sizer, '2. Eligibility'),
//                     _paragraph(
//                       sizer,
//                       'You must be at least 18 years old to use Match At First Swipe. By using the app, you confirm that you meet this age requirement.',
//                     ),

//                     _title(sizer, '3. Account Creation'),
//                     _bullet(
//                       sizer,
//                       'You are responsible for the accuracy of the information provided during account creation.',
//                     ),
//                     _bullet(
//                       sizer,
//                       'You agree not to impersonate others or create multiple accounts.',
//                     ),

//                     _title(sizer, '4. App Usage'),
//                     _bullet(
//                       sizer,
//                       'Match At First Swipe is for personal use only. Commercial use, unauthorized access, and data scraping are prohibited.',
//                     ),
//                     _bullet(
//                       sizer,
//                       'Users must adhere to our community guidelines and respect other users.',
//                     ),

//                     _title(sizer, '5. Privacy'),
//                     _paragraph(
//                       sizer,
//                       'Your privacy is important to us. Please review our Privacy Policy for details on data collection, use, and protection.',
//                     ),

//                     _title(sizer, '6. Safety'),
//                     _bullet(
//                       sizer,
//                       'We prioritize user safety. Report any suspicious or inappropriate behavior promptly.',
//                     ),
//                     _bullet(
//                       sizer,
//                       'Do not share personal or financial information with other users.',
//                     ),

//                     _title(sizer, '7. Premium Services'),
//                     _paragraph(
//                       sizer,
//                       'Match At First Swipe offers premium subscription services with added features. Payment terms and renewals are detailed in the app.',
//                     ),

//                     _title(sizer, '8. Termination'),
//                     _paragraph(
//                       sizer,
//                       'Match At First Swipe reserves the right to suspend or terminate accounts for violations of our terms or misuse of the platform.',
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
