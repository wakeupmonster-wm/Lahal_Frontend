// // =============================
// // lib/screens/typography_showcase.dart
// // Visual test screen: sizes × weights × colors in light/dark
// // =============================

// import 'package:flutter/material.dart';
// import 'package:mafs/utils/theme/text/app_text.dart';
// import 'package:mafs/utils/theme/text/app_text_color.dart';
// import 'package:mafs/utils/theme/app_tokens.dart';
// import 'package:mafs/utils/theme/text/app_typography.dart';

// class TypographyShowcase extends StatefulWidget {
//   const TypographyShowcase({super.key, this.onToggleTheme});
//   final VoidCallback? onToggleTheme;

//   @override
//   State<TypographyShowcase> createState() => _TypographyShowcaseState();
// }

// class _TypographyShowcaseState extends State<TypographyShowcase> {
//   // Default selected token for sample text
//   String _selectedToken = 'neutral';

//   @override
//   Widget build(BuildContext context) {
//     final c = Theme.of(context).extension<AppTextColors>()!;
//     final tok = Theme.of(context).extension<AppTokens>()!;
//     const sizes = AppTextSize.values;
//     const weights = AppTextWeight.values;

//     final colorRows = <MapEntry<String, Color>>[
//       MapEntry('primary', c.primary),
//       MapEntry('secondary', c.secondary),
//       MapEntry('tertiary', c.tertiary),
//       MapEntry('neutral', c.neutral),
//       MapEntry('subtle', c.subtle),
//       MapEntry('inverse', c.inverse),
//       MapEntry('info', c.info),
//       MapEntry('warning', c.warning),
//       MapEntry('error', c.error),
//     ];

//     Color _colorFor(String key) {
//       switch (key) {
//         case 'primary':
//           return c.primary;
//         case 'secondary':
//           return c.secondary;
//         case 'tertiary':
//           return c.tertiary;
//         case 'neutral':
//           return c.neutral;
//         case 'subtle':
//           return c.subtle;
//         case 'inverse':
//           return c.inverse;
//         case 'info':
//           return c.info;
//         case 'warning':
//           return c.warning;
//         case 'error':
//           return c.error;
//         default:
//           return Theme.of(context).colorScheme.onSurface;
//       }
//     }

//     final sampleColor = _colorFor(_selectedToken);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Typography Showcase'),
//         actions: [
//           if (widget.onToggleTheme != null)
//             IconButton(
//               tooltip: 'Toggle theme',
//               icon: const Icon(Icons.brightness_6),
//               onPressed: widget.onToggleTheme,
//             ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.symmetric(
//           horizontal: tok.inset.screenH,
//           vertical: tok.inset.screenV,
//         ),
//         children: [
//           // ====== Color token picker ======
//           AppText(
//             'Pick a text color token',
//             size: AppTextSize.s14,
//             weight: AppTextWeight.semibold,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//           SizedBox(height: tok.gap.sm),
//           Wrap(
//             spacing: tok.gap.sm,
//             // runSpacing: 0,
//             children: [
//               for (final entry in colorRows)
//                 ChoiceChip(
//                   label: AppText(
//                     entry.key,
//                     size: AppTextSize.s12,
//                     weight: AppTextWeight.medium,
//                     color: entry.value,
//                   ),
//                   selected: _selectedToken == entry.key,
//                   onSelected: (_) => setState(() => _selectedToken = entry.key),
//                   selectedColor: entry.value.withOpacity(0.12),
//                   shape: StadiumBorder(
//                     side: BorderSide(color: entry.value.withOpacity(0.6)),
//                   ),
//                 ),
//             ],
//           ),

//           SizedBox(height: tok.gap.lg),
//           const Divider(),
//           SizedBox(height: tok.gap.lg),

//           // ====== Sizes × Weights using selected color ======
//           AppText(
//             'Sizes × Weights',
//             size: AppTextSize.s18,
//             weight: AppTextWeight.bold,
//             color: Theme.of(context).colorScheme.onSurface,
//             //  colorToken: Theme.of(context).extension<AppTextColors>()!.neutral,
//           ),
//           SizedBox(height: tok.gap.md),

//           for (final s in sizes) ...[
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(tok.inset.card),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       'Size: $s',
//                       size: s,
//                       weight: AppTextWeight.semibold,
//                       color: sampleColor,
//                     ),
//                     SizedBox(height: tok.gap.sm),
//                     Wrap(
//                       spacing: tok.gap.md,
//                       runSpacing: tok.gap.sm,
//                       children: [
//                         for (final w in weights)
//                           AppText(
//                             'The quick brown fox — ${w.name}',
//                             size: s,
//                             weight: w,
//                             color: sampleColor,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: tok.gap.lg),
//           ],

//           const Divider(),
//           SizedBox(height: tok.gap.lg),

//           // ====== Swatches (unchanged) ======
//           AppText(
//             'Color Tokens',
//             size: AppTextSize.s18,
//             weight: AppTextWeight.bold,
//           ),
//           SizedBox(height: tok.gap.md),
//           Card(
//             child: Padding(
//               padding: EdgeInsets.all(tok.inset.card),
//               child: Wrap(
//                 spacing: tok.gap.md,
//                 runSpacing: tok.gap.sm,
//                 children: [
//                   for (final entry in colorRows)
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: tok.gap.sm,
//                         horizontal: tok.gap.md,
//                       ),
//                       decoration: BoxDecoration(
//                         color: entry.value.withOpacity(0.07),
//                         borderRadius: BorderRadius.circular(tok.radiusSm),
//                       ),
//                       child: AppText(
//                         entry.key,
//                         size: AppTextSize.s14,
//                         weight: AppTextWeight.medium,
//                         color: entry.value,
//                       ),
//                     ),
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
// //
