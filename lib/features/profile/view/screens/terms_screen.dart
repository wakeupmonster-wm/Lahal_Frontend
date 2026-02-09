import 'package:flutter/material.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.termsOfService,
        centerTitle: false,
      ),

      body: Center(
        child: AppText(
          "Terms of Service Content Here",
          size: AppTextSize.s16,
          color: tx.subtle,
        ),
      ),
    );
  }
}
