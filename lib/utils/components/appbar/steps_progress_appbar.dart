// // lib/utils/components/appbar/step_progress_app_bar.dart
// import 'package:flutter/material.dart';
// import 'package:lahal_application/features/profile_setup/controller/profile_setup_controller.dart';
// import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';

// /// Small wrapper to compute progress for step-based onboarding.
// /// Usage:
// ///   appBar: StepProgressAppBar(stepIndex: controller.currentStep)
// class StepProgressAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const StepProgressAppBar({
//     super.key,
//     required this.stepIndex,
//     this.totalSteps = 11,
//   });

//   final int stepIndex;
//   final int totalSteps;

//   double get _progress {
//     final s = stepIndex.clamp(0, totalSteps);
//     return s / totalSteps;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = ProfileSetupController.instance;
//     return InternalAppBar(
//       progress: _progress,
//       onBack: ctrl.goBack,
//     );
//   }

//   // delegate preferred size from InternalAppBar – if InternalAppBar implements PreferredSize,
//   // you can match its height. If not, give a safe default.
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
// }
