import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

/// Reusable dropdown that follows AppTokens and AppTextColors
/// - Supports optional label (heading)
/// - uses color tokens similar to AppTextField
class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    required this.itemBuilder,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final String? label;
  final String hintText;
  final List<T> items;
  final String Function(T) itemBuilder;
  final T? value;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tc = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final tp = Theme.of(context).extension<AppTypography>()!;

    // Colors according to your request
    final Color textColor = tc.neutral; // main text color
    Color hintColor = tc.muted; // muted/hint color
    final Color fillColor = cs.surfaceContainerHighest; // background
    final Color focusColor = cs.primary; // focused border
    final Color disabledColor = cs.onSurface.withOpacity(0.12);

    // text style (use your typography tokens)
    final textStyle = tp.style(
      context,
      size: AppTextSize.s16,
      weight: AppTextWeight.medium,
      color: textColor,
    );

    final hintStyle = tp.style(
      context,
      size: AppTextSize.s16,
      weight: AppTextWeight.semibold,
      color: hintColor,
    );

    final disabledHintStyle = hintStyle.copyWith(
      color: tc.muted.withOpacity(0.6), // slightly more muted
    );

    // border radius from tokens
    final radius = tok.radiusMd;

    // InputDecoration with different border states
    final inputDecoration = InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: tok.inset.section,
        vertical: tok.inset.section,
      ),
      filled: true,
      fillColor: fillColor,

      // hintText: widget.hintText,
      // hintStyle: hintStyle,
      // hint: Text(widget.hintText, style: hintStyle),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: tok.gap.xs),
        child: IconTheme(
          data: IconThemeData(
            size: tok.iconLg,
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ),
      // suffixIconConstraints: BoxConstraints(minWidth: tok.iconLg + tok.gap.sm),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: disabledColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: cs.error, width: 1.6),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppText(
            widget.label!,
            size: AppTextSize.s16,
            weight: AppTextWeight.semibold,
            color: tc.neutral,
          ),
          SizedBox(height: tok.gap.sm),
        ],
        DropdownButtonFormField<T>(
          focusNode: _focusNode,
          initialValue: widget.value,
          items: widget.items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: AppText(
                    widget.itemBuilder(item),
                    size: AppTextSize.s16,
                    weight: AppTextWeight.medium,
                    color: tc.neutral,
                  ),
                ),
              )
              .toList(),
          onChanged: widget.enabled ? widget.onChanged : null,
          validator: widget.validator,
          decoration: inputDecoration,
          style: textStyle,
          isExpanded: true,
          //icon: const SizedBox.shrink(),
          dropdownColor: fillColor,
          // <-- Important: give the Dropdown a hint widget that uses your hintStyle
          hint: Text(widget.hintText, style: hintStyle),
          // <-- when disabled, show a disabled hint style (optional)
          disabledHint: Text(widget.hintText, style: disabledHintStyle),
        ),
      ],
    );
  }
}


// Mistakes in the code 
// 1. Sizes are not as per figma
// 2. Missed layout as per figma 