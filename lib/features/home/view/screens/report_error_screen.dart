import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/controller/report_error_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class ReportErrorScreen extends StatelessWidget {
  const ReportErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportErrorController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: InternalAppBar(title: 'Report and Error', centerTitle: false),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(tok.gap.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Options List
                      Obx(
                        () => Column(
                          children: controller.options.entries.map((entry) {
                            return _buildOptionTile(
                              context,
                              entry.key,
                              entry.value,
                              (val) {
                                controller.toggleOption(entry.key);
                                // Trigger update manually since we are mutating the map value directly in the controller
                                // controller.options.refresh();
                              },
                              tok,
                              tx,
                              cs,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: tok.gap.xl),
                      const Divider(thickness: 1, color: Color(0xFFE5E7EB)),
                      SizedBox(height: tok.gap.xl),

                      // More Info TextField
                      Container(
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(tok.radiusMd),
                        ),
                        child: TextField(
                          controller: controller.moreInfoController,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 14,
                            color: tx.neutral,
                            fontFamily: 'Inter', // Assuming Inter font
                          ),
                          decoration: InputDecoration(
                            hintText: 'More info',
                            hintStyle: TextStyle(
                              color: tx.subtle,
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.all(tok.gap.md),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Submit Button
              Obx(() {
                final isEnabled = controller.isSubmitEnabled;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () => controller.submit(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled
                          ? const Color(0xFF047857)
                          : Colors
                                .transparent, // Disabled color handled by theme usually, but explicit request
                      disabledBackgroundColor: Colors.transparent,
                      foregroundColor: isEnabled ? Colors.white : tx.subtle,
                      padding: EdgeInsets.symmetric(vertical: tok.gap.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(tok.radiusMd),
                        side: BorderSide(
                          color: isEnabled
                              ? const Color(0xFF047857)
                              : Colors.grey.withOpacity(0.4),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: AppText(
                      'Submit',
                      size: AppTextSize.s16,
                      weight: AppTextWeight.medium,
                      color: isEnabled ? Colors.white : tx.subtle,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String label,
    bool isSelected,
    Function(bool?) onChanged,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: tok.gap.md),
      child: GestureDetector(
        onTap: () => onChanged(!isSelected),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: const Color(0xFF047857),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF047857)
                      : Colors.grey.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
            SizedBox(width: tok.gap.sm),
            AppText(label, size: AppTextSize.s14, color: tx.neutral),
          ],
        ),
      ),
    );
  }
}
