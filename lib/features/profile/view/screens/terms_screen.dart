import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lahal_application/features/profile/controller/cms_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CmsController());
    // Trigger fetch when screen loads
    controller.fetchTerms();
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.termsOfService,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isTermsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(tok.gap.lg),
            child: Html(
              data: controller.termsData.value,
              style: {
                "body": Style(
                  color: tx.neutral,
                  fontSize: FontSize(16),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "h1": Style(
                  color: tx.primary,
                  fontSize: FontSize(22),
                  fontWeight: FontWeight.bold,
                ),
                "p": Style(color: tx.subtle, lineHeight: const LineHeight(1.5)),
              },
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          );
        }),
      ),
    );
  }
}
