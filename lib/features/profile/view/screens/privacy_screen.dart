import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lahal_application/features/profile/controller/cms_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/components/widgets/warning_dispaly.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CmsController());

    // Trigger fetch when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPrivacyPolicy();
    });

    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface.withOpacity(0.95),
      appBar: InternalAppBar(
        title: AppStrings.privacyPolicy,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return WarningDisplay(
              warningMessage: "Oops! Something went wrong",
              subWarningMessage: controller.errorMessage.value,
              onRetry: () => controller.fetchPrivacyPolicy(),
            );
          }

          if (controller.privacyData.value.content.isEmpty) {
            return const WarningDisplay(
              warningMessage: "No Content Found",
              subWarningMessage: "The privacy policy is currently unavailable.",
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: tok.inset.screenH,
              vertical: tok.inset.screenV,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(tok.inset.card),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(tok.radiusLg),

                border: Border.all(color: tx.neutral.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.privacyData.value.title.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(height: tok.gap.sm),
                          AppText(
                            controller.privacyData.value.title,
                            size: AppTextSize.s24,
                            weight: AppTextWeight.bold,
                            color: tx.neutral,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: tok.gap.sm),
                          const Divider(),
                          SizedBox(height: tok.gap.md),
                        ],
                      ),
                    ),
                  ],
                  Html(
                        data: controller.privacyData.value.content
                            .replaceAll("&nbsp;", " ")
                            .replaceAll("\\n", "")
                            .trim(),
                        style: {
                          "body": Style(
                            color: tx.neutral,
                            fontSize: FontSize(16),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w400,
                          ),
                          "h1,h2,h3,h4,h5,h6": Style(
                            color: tx.primary,
                            fontWeight: FontWeight.bold,
                            margin: Margins.only(top: 16, bottom: 8),
                          ),
                          "p": Style(
                            color: tx.subtle,
                            lineHeight: const LineHeight(1.6),
                            margin: Margins.only(bottom: 12),
                          ),
                          "ol,ul": Style(
                            margin: Margins.only(left: 16, bottom: 12),
                          ),
                          "li": Style(margin: Margins.only(bottom: 8)),
                        },
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
