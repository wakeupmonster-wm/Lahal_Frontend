import 'package:flutter/material.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class UseCurrentLocationTile extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const UseCurrentLocationTile({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tok.inset.fieldH,
          vertical: tok.inset.fieldV,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.9)),
        ),
        child: Row(
          children: [
            Icon(Icons.my_location, color: AppColor.primaryColor, size: 20),
            SizedBox(width: tok.gap.md),
            Expanded(
              child: AppText(
                label,
                size: AppTextSize.s14,
                weight: AppTextWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            Icon(Icons.chevron_right, color: tx.subtle, size: 20),
          ],
        ),
      ),
    );
  }
}
