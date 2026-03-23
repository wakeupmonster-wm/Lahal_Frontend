import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lahal_application/features/home/controller/report_error_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class ReportErrorScreen extends StatelessWidget {
  final String restaurantId;
  const ReportErrorScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportErrorController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

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
                              },
                              tok,
                              tx,
                              cs,
                              width,
                              height,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: tok.gap.xl),
                      const Divider(thickness: 1, color: Color(0xFFE5E7EB)),
                      SizedBox(height: tok.gap.xl),

                      // More Info TextField
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(tok.radiusLg),
                          border: Border.all(
                            color: cs.outlineVariant.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.moreInfoController,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 14,
                            color: tx.neutral,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                          ),

                          decoration: InputDecoration(
                            hintText: 'More info',
                            hintStyle: TextStyle(
                              color: tx.subtle,
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.all(tok.gap.md),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
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
                  height: height * 0.06,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () => controller.submit(context, restaurantId)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled
                          ? const Color(0xFF047857)
                          : Colors
                                .transparent, // Disabled color handled by theme usually, but explicit request
                      disabledBackgroundColor: Colors.transparent,
                      foregroundColor: isEnabled ? Colors.white : tx.subtle,
                      // padding: EdgeInsets.symmetric(vertical: tok.gap.md),
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
    double width,
    double height,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: tok.gap.md),
      child: GestureDetector(
        onTap: () => onChanged(!isSelected),
        child: Row(
          children: [
            SizedBox(
              height: height * 0.025,
              width: width * 0.055,
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
                  width: 2,
                ),
              ),
            ),
            SizedBox(width: tok.gap.sm),
            AppText(
              label,
              size: AppTextSize.s16,
              color: tx.neutral,
              weight: AppTextWeight.semibold,
            ),
          ],
        ),
      ),
    );
  }
}
