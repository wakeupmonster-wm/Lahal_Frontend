import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

class LocationSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const LocationSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: cs.primary),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: tx.primary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: tx.subtle, fontSize: tok.radiusLg),
          prefixIcon: Icon(Icons.search, color: tx.primary, size: tok.iconSm),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(tok.radiusMd),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: tok.gap.sm),
        ),
      ),
    );
  }
}
