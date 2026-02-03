import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class GenderSelectionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final tok = Theme.of(context).extension<AppTokens>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tok.gap.lg,
          vertical: tok.gap.md,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? cs.primary : AppPalette.strokeVariant,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Title on the left
            Expanded(
              child: AppText(
                label,
                size: AppTextSize.s16,
                weight: AppTextWeight.medium,
                color: tx.neutral,
              ),
            ),
            // Checkbox on the right
            _GenderCheckbox(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _GenderCheckbox extends StatelessWidget {
  final bool isSelected;

  const _GenderCheckbox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? cs.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? cs.primary : AppPalette.strokeVariant,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? Center(child: Icon(Icons.check, size: 16, color: cs.onPrimary))
          : null,
    );
  }
}
