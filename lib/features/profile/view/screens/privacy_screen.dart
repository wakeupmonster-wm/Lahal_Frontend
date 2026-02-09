import 'package:flutter/material.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.privacyPolicy,
        centerTitle: false,
      ),
      body: Center(
        child: AppText(
          AppStrings.privacyPolicy,
          size: AppTextSize.s18,
          weight: AppTextWeight.bold,
          color: tx.neutral,
        ),
      ),
    );
  }
}
