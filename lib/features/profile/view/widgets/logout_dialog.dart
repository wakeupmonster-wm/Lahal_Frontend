// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lahal_application/utils/constants/app_strings.dart';
// import 'package:lahal_application/utils/theme/app_tokens.dart';
// import 'package:lahal_application/utils/theme/text/app_text.dart';
// import 'package:lahal_application/utils/theme/text/app_typography.dart';
// import 'package:lahal_application/utils/theme/text/app_text_color.dart';
// import 'package:lahal_application/utils/theme/app_button.dart';

// class LogoutBottomSheet extends StatefulWidget {
//   final VoidCallback onConfirm;

//   const LogoutBottomSheet({super.key, required this.onConfirm});

//   static void show(BuildContext context, {required VoidCallback onConfirm}) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => LogoutBottomSheet(onConfirm: onConfirm),
//     );
//   }

//   @override
//   State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
// }

// class _LogoutBottomSheetState extends State<LogoutBottomSheet>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;

//   // Staggered Animations
//   late Animation<Offset> _pullBarSlide;
//   late Animation<double> _pullBarFade;

//   late Animation<Offset> _titleSlide;
//   late Animation<double> _titleFade;

//   late Animation<Offset> _messageSlide;
//   late Animation<double> _messageFade;

//   late Animation<Offset> _buttonsSlide;
//   late Animation<double> _buttonsFade;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     // 1. Pull Bar (0-30%)
//     _pullBarSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.0, 0.3, curve: Curves.easeOutQuad),
//           ),
//         );
//     _pullBarFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
//       ),
//     );

//     // 2. Title (10-40%)
//     _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.1, 0.4, curve: Curves.easeOutQuad),
//           ),
//         );
//     _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
//       ),
//     );

//     // 3. Message (20-50%)
//     _messageSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.2, 0.5, curve: Curves.easeOutQuad),
//           ),
//         );
//     _messageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
//       ),
//     );

//     // 4. Buttons (30-60%)
//     _buttonsSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _animController,
//             curve: const Interval(0.3, 0.6, curve: Curves.easeOutQuad),
//           ),
//         );
//     _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
//       ),
//     );

//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tok = Theme.of(context).extension<AppTokens>();
//     final tx = Theme.of(context).extension<AppTextColors>();
//     final cs = Theme.of(context).colorScheme;

//     if (tok == null || tx == null) return const SizedBox();

//     return Container(
//       padding: EdgeInsets.all(tok.gap.lg),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(tok.radiusLg * 2),
//           topRight: Radius.circular(tok.radiusLg * 2),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Pull Bar
//           FadeTransition(
//             opacity: _pullBarFade,
//             child: SlideTransition(
//               position: _pullBarSlide,
//               child: Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: cs.outlineVariant,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: tok.gap.lg),

//           // Title
//           FadeTransition(
//             opacity: _titleFade,
//             child: SlideTransition(
//               position: _titleSlide,
//               child: AppText(
//                 AppStrings.wantToLogout,
//                 size: AppTextSize.s18,
//                 weight: AppTextWeight.bold,
//                 color: tx.neutral,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           SizedBox(height: tok.gap.md),

//           // Message
//           FadeTransition(
//             opacity: _messageFade,
//             child: SlideTransition(
//               position: _messageSlide,
//               child: AppText(
//                 AppStrings.logoutConfirmation,
//                 size: AppTextSize.s14,
//                 color: tx.subtle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           SizedBox(height: tok.gap.xl),

//           // Buttons
//           FadeTransition(
//             opacity: _buttonsFade,
//             child: SlideTransition(
//               position: _buttonsSlide,
//               child: Column(
//                 children: [
//                   AppButton(
//                     label: AppStrings.logout,
//                     onPressed: widget.onConfirm,
//                     variant: AppButtonVariant.danger,
//                     minWidth: double.infinity,
//                     radiusOverride: 12,
//                   ),
//                   SizedBox(height: tok.gap.md),
//                   AppButton(
//                     label: AppStrings.cancel,
//                     onPressed: () => context.pop(),
//                     variant: AppButtonVariant.ghost,
//                     minWidth: double.infinity,
//                     radiusOverride: 12,
//                     // bgColorOverride: cs.surfaceContainerHighest.withOpacity(
//                     //   0.5,
//                     // ),
//                     // fgColorOverride: tx.primary,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: tok.gap.lg),
//         ],
//       ),
//     );
//   }
// }
