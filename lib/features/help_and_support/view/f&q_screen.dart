// import 'package:flutter/material.dart';

// import '../../../utils/components/text/app_text.dart';
// import '../../../utils/constants/app_sizer.dart';

// class FaqScreen extends StatefulWidget {
//   const FaqScreen({super.key});

//   @override
//   State<FaqScreen> createState() => _FaqScreenState();
// }

// class _FaqScreenState extends State<FaqScreen> {
//   int selectedCategory = 0;
//   int expandedIndex = 0;

//   final categories = ['General', 'Account', 'Dating', 'Subscription'];

//   final faqs = [
//     {
//       'q': 'What is Match At First Swipe?',
//       'a':
//       'Match At First Swipe is a dating app designed to help you meet new people, make meaningful connections, and find potential matches based on your interests and preferences.',
//     },
//     {
//       'q': 'How do I create a Match At First Swipe account?',
//       'a': 'You can sign up using your email or phone number and complete your profile.',
//     },
//     {
//       'q': 'Is Match At First Swipe free to use?',
//       'a': 'Yes, the app offers free features with optional premium upgrades.',
//     },
//     {
//       'q': 'How does matching work on Match At First Swipe?',
//       'a': 'Matching occurs when two users like each other’s profiles.',
//     },
//     {
//       'q': 'Can I change my location on Match At First Swipe?',
//       'a': 'Yes, location settings can be updated in your profile preferences.',
//     },
//   ];

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
//                       text: 'FAQ',
//                       fontSize: sizer.w(18),
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: sizer.h(20)),

//             // ---------- Category Chips ----------
//             SizedBox(
//               height: sizer.h(40),
//               child: ListView.separated(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(20)),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categories.length,
//                 separatorBuilder: (_, __) => SizedBox(width: sizer.w(10)),
//                 itemBuilder: (context, index) {
//                   final selected = index == selectedCategory;
//                   return GestureDetector(
//                     onTap: () => setState(() => selectedCategory = index),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: sizer.w(18),
//                         vertical: sizer.h(8),
//                       ),
//                       decoration: BoxDecoration(
//                         color: selected
//                             ? const Color(0xFF2FB6B3)
//                             : Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(sizer.w(20)),
//                         border: Border.all(
//                           color: selected
//                               ? Colors.transparent
//                               : Colors.grey.withOpacity(0.3),
//                         ),
//                       ),
//                       child: PlusJakartaSans(
//                         text: categories[index],
//                         fontSize: sizer.w(14),
//                         fontWeight: FontWeight.w600,
//                         color:
//                         selected ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             SizedBox(height: sizer.h(18)),

//             // ---------- Search ----------
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: sizer.w(20)),
//               child: Container(
//                 height: sizer.h(46),
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(14)),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.06),
//                   borderRadius:
//                   BorderRadius.circular(sizer.w(12)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search,
//                         size: sizer.w(18), color: Colors.grey),
//                     SizedBox(width: sizer.w(10)),
//                     Expanded(
//                       child: TextField(
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Search',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: sizer.h(18)),

//             // ---------- FAQ List ----------
//             Expanded(
//               child: ListView.separated(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(20)),
//                 itemCount: faqs.length,
//                 separatorBuilder: (_, __) =>
//                     SizedBox(height: sizer.h(12)),
//                 itemBuilder: (context, index) {
//                   final isExpanded = index == expandedIndex;
//                   final faq = faqs[index];

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         expandedIndex =
//                         isExpanded ? -1 : index;
//                       });
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(sizer.w(16)),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                         BorderRadius.circular(sizer.w(14)),
//                         border: Border.all(
//                           color: Colors.grey.withOpacity(0.2),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: PlusJakartaSans(
//                                   text: faq['q']!,
//                                   fontSize: sizer.w(15),
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               Icon(
//                                 isExpanded
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                                 color: Colors.black54,
//                               ),
//                             ],
//                           ),
//                           if (isExpanded) ...[
//                             SizedBox(height: sizer.h(12)),
//                             Divider(
//                               color:
//                               Colors.grey.withOpacity(0.2),
//                             ),
//                             SizedBox(height: sizer.h(12)),
//                             PlusJakartaSans(
//                               text: faq['a']!,
//                               fontSize: sizer.w(14),
//                               height: 1.5,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey[700],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
