import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/controller/faq_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/textfields/app_search_text_field.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/components/widgets/warning_dispaly.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaqController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(title: AppStrings.faqs, centerTitle: false),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(tok.gap.lg),
              child: AppSearchField(
                hintText: "Search",
                controller: controller.searchController,
                onChanged: controller.onSearch,
              ),
            ),

            // FAQ List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value) {
                  return WarningDisplay(
                    onRetry: () => controller.fetchFaqs(),
                    warningMessage: "Something went wrong",
                    subWarningMessage:
                        "We couldn't load the FAQs. Please try again.",
                  );
                }

                if (controller.filteredFaqs.isEmpty) {
                  return EmptyStateWidget(
                    imagePath: AppAssets.emptyStateImage,
                    title: 'No notifications yet',
                    description:
                        'We will notify you when something important happens.',
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
                  itemCount: controller.filteredFaqs.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: tok.gap.md),
                  itemBuilder: (context, index) {
                    final faq = controller.filteredFaqs[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(tok.radiusMd),
                        border: Border.all(
                          color: cs.outlineVariant.withOpacity(0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          onExpansionChanged: (_) =>
                              controller.toggleExpansion(index),
                          initiallyExpanded: faq.isExpanded,
                          title: AppText(
                            faq.question,
                            size: AppTextSize.s16,
                            weight: AppTextWeight.semibold,
                            color: tx.primary,
                          ),
                          trailing: Icon(
                            faq.isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                tok.gap.md,
                                0,
                                tok.gap.md,
                                tok.gap.md,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(color: cs.outlineVariant),
                                  SizedBox(height: tok.gap.sm),
                                  AppText(
                                    faq.answer,
                                    size: AppTextSize.s14,
                                    color: tx.subtle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
