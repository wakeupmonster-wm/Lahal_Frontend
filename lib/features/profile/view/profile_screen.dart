// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';

// import '../../../utils/components/text/app_text.dart' show PlusJakartaSans;
// import '../../../utils/constants/app_colors.dart';
// import '../../../utils/constants/app_sizer.dart' show SizeConfig;
// import '../../../utils/constants/app_svg.dart';
// import '../../../utils/routes/app_pages.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   // sample plan data
//   List<Map<String, String>> _plans() => [
//     {
//       'title': 'Aqua Drift',
//       'tag': 'Basic',
//       'subtitle': 'Go with the flow — start your story with real matches.',
//     },
//     {
//       'title': 'Purple Tide',
//       'tag': 'Pro',
//       'subtitle': 'Go deeper — more visibility & perks for you.',
//     },
//   ];

//   // sample feature rows for comparison
//   List<Map<String, dynamic>> _features() => [
//     {'title': 'Unlimited likes', 'drift': true, 'tide': true},
//     {'title': 'Create and Edit Profile', 'drift': true, 'tide': true},
//     {'title': 'Swipe Match', 'drift': true, 'tide': true},
//     {'title': 'Limited Daily Swipes', 'drift': true, 'tide': false},
//     {'title': 'Basic Profile Verification', 'drift': true, 'tide': true},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final sizer = SizeConfig(context);
//     final plans = _plans();
//     final features = _features();

//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(vertical: sizer.h(12)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(18)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     PlusJakartaSans(
//                       text: 'Profile',
//                       fontSize: sizer.w(20),
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         context.push(AppRoutes.profileSettingScreen);
//                       },
//                       icon: Icon(Icons.settings_outlined, size: sizer.w(24), color: Colors.grey[700]),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: sizer.h(12)),

//               // Avatar row
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(18)),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // avatar with progress ring
//                     Container(
//                       width: sizer.w(100),
//                       height: sizer.w(100),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           // ---- PROGRESS RING (outer) ----
//                           SizedBox(
//                             width: sizer.w(82),
//                             height: sizer.w(82),
//                             child: Transform.rotate(
//                               // rotate so the progress START point moves to bottom-left
//                               angle: 3.14159, // 180° rotation → start from LEFT
//                               child: CircularProgressIndicator(
//                                 value: 0.25,
//                                 // 0.0 - 1.0
//                                 strokeWidth: sizer.w(6),
//                                 backgroundColor: AppColor.primaryColor.withOpacity(0.12),
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppColor.primaryColor,
//                                 ),
//                                 strokeCap: StrokeCap.round,
//                               ),
//                             ),
//                           ),

//                           // ---- AVATAR (inner circle) ----
//                           Container(
//                             width: sizer.w(78),
//                             height: sizer.w(78),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ],
//                             ),

//                             child: ClipOval(
//                               child: Image.network(
//                                 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),

//                           // ---- PERCENT BADGE (same start point: bottom-left) ----
//                           Positioned(
//                             bottom: sizer.h(1),
//                             left: sizer.w(30),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: sizer.w(6),
//                                 vertical: sizer.h(1),
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColor.primaryColor,
//                                 borderRadius: BorderRadius.circular(sizer.w(12)),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.06),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: PlusJakartaSans(
//                                 text: '${(0.25 * 100).toInt()}%',
//                                 fontSize: sizer.w(10),
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(width: sizer.w(12)),

//                     // name + edit button
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             PlusJakartaSans(
//                               text: 'John (24)',
//                               fontSize: sizer.w(18),
//                               fontWeight: FontWeight.w700,
//                               color: Colors.black87,
//                             ),
//                             SizedBox(width: sizer.w(8)),
//                             Container(
//                               width: sizer.w(22),
//                               height: sizer.w(22),
//                               decoration: BoxDecoration(
//                                 color: AppColor.primaryColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(Icons.check, size: sizer.w(16), color: Colors.white),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: sizer.h(8)),
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColor.primaryColor,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizer.w(21))),
//                             padding: EdgeInsets.symmetric(horizontal: sizer.w(10)),
//                             elevation: 0,
//                           ),
//                           child: PlusJakartaSans(
//                             text: 'Edit Profile',
//                             fontSize: sizer.w(12),
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: sizer.h(18)),

//               // Super Likes pill
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(18)),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: sizer.w(14), vertical: sizer.h(12)),
//                   decoration: BoxDecoration(
//                     color: AppColor.primaryColor.withAlpha(20),
//                     borderRadius: BorderRadius.circular(sizer.w(14)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColor.primaryColor.withOpacity(0.06),
//                         blurRadius: 24,
//                         offset: const Offset(0, 12),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: sizer.w(65),
//                         height: sizer.w(65),
//                         padding: EdgeInsets.all(sizer.w(10)),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: AppColor.white,
//                         ),
//                         child: SvgPicture.asset(
//                           AppSvg.star,
//                         ),
//                       ),

//                       SizedBox(width: sizer.w(12)),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             PlusJakartaSans(
//                               text: 'Super Likes',
//                               fontSize: sizer.w(14),
//                               fontWeight: FontWeight.w700,
//                               color: Colors.black87,
//                             ),
//                             SizedBox(height: sizer.h(4)),
//                             PlusJakartaSans(
//                               text: 'Make them notice you 👋',
//                               fontSize: sizer.w(12),
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey[700]!,
//                             ),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColor.primaryColor,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizer.w(12))),
//                           padding: EdgeInsets.symmetric(horizontal: sizer.w(12), vertical: sizer.h(8)),
//                           elevation: 0,
//                         ),
//                         child: PlusJakartaSans(
//                           text: 'Get more',
//                           fontSize: sizer.w(10),
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               SizedBox(height: sizer.h(18)),

//               // Plans horizontal page view
//               Container(
//                 height: sizer.h(220),
//                 child: PageView.builder(
//                   controller: PageController(viewportFraction: 1),
//                   itemCount: plans.length,
//                   padEnds: true,

//                   itemBuilder: (context, index) {
//                     final plan = plans[index];
//                     return Padding(
//                       padding: EdgeInsets.symmetric(horizontal: sizer.w(12)),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(sizer.w(16)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.06),
//                               blurRadius: 18,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),

//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               height: 150,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                   sizer.w(16),
//                                 ),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     AppColor.white.withOpacity(0.1),
//                                     AppColor.white.withOpacity(0.12),
//                                     AppColor.primaryColor2.withOpacity(0.1),
//                                     AppColor.primaryColor2,
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                               padding: EdgeInsets.all(sizer.w(16)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       PlusJakartaSans(
//                                         text: plan['title']!,
//                                         fontSize: sizer.w(16),
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: sizer.w(10),
//                                           vertical: sizer.h(6),
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.black87,
//                                           borderRadius: BorderRadius.circular(sizer.w(14)),
//                                         ),
//                                         child: PlusJakartaSans(
//                                           text: plan['tag']!,
//                                           fontSize: sizer.w(12),
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: sizer.h(8)),
//                                   PlusJakartaSans(
//                                     text: plan['subtitle']!,
//                                     fontSize: sizer.w(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey[800]!,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: sizer.w(2),
//                                 vertical: sizer.h(10),
//                               ),
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () {},
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.black,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(sizer.w(30)),
//                                     ),
//                                     padding: EdgeInsets.symmetric(vertical: sizer.h(14)),
//                                     elevation: 0,
//                                   ),
//                                   child: PlusJakartaSans(
//                                     text: 'Explore Plan',
//                                     fontSize: sizer.w(14),
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               SizedBox(height: sizer.h(30)),

//               // What you get table header
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(18)),
//                 child: PlusJakartaSans(
//                   text: 'What you get:',
//                   fontSize: sizer.w(16),
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),

//               SizedBox(height: sizer.h(12)),

//               // Table header for Drift / Tide
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(18)),
//                 child: Row(
//                   children: [
//                     Expanded(child: SizedBox()), // feature title column
//                     SizedBox(width: sizer.w(8)),
//                     SizedBox(
//                       width: sizer.w(80),
//                       child: Center(
//                         child: PlusJakartaSans(text: 'Drift', fontSize: sizer.w(14), fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     SizedBox(width: sizer.w(8)),
//                     SizedBox(
//                       width: sizer.w(80),
//                       child: Center(
//                         child: PlusJakartaSans(text: 'Tide', fontSize: sizer.w(14), fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: sizer.h(6)),

//               // Features list
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizer.w(18)),
//                 child: Column(
//                   children: List.generate(features.length, (i) {
//                     final f = features[i];
//                     return Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: PlusJakartaSans(
//                                 text: f['title'] as String,
//                                 fontSize: sizer.w(14),
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[800]!,
//                               ),
//                             ),
//                             SizedBox(width: sizer.w(8)),
//                             SizedBox(
//                               width: sizer.w(80),
//                               child: Center(
//                                 child: Icon(
//                                   (f['drift'] as bool) ? Icons.check : Icons.clear,
//                                   color: (f['drift'] as bool) ? AppColor.primaryColor : Colors.grey[400],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: sizer.w(8)),
//                             SizedBox(
//                               width: sizer.w(80),
//                               child: Center(
//                                 child: Icon(
//                                   (f['tide'] as bool) ? Icons.check : Icons.clear,
//                                   color: (f['tide'] as bool) ? AppColor.primaryColor : Colors.grey[400],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: sizer.h(14)),
//                       ],
//                     );
//                   }),
//                 ),
//               ),

//               // bottom spacing for nav
//               SizedBox(height: sizer.h(120)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
