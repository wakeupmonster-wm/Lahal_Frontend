// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

/// Reusable text field that follows AppTokens and AppTextColors
/// - Supports optional label (heading)
/// - prefix widget, validator, onChange, onSubmit, controller
/// - uses color tokens:
///   * hint color => AppPalette.textMuted / tx.subtle
///   * text color => tx.neutral
///   * background => colorScheme.surfaceContainerHighest
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label, // optional heading above the field
    this.labelSize,
    required this.hintText,
    this.prefix,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.isOutline = false,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.maxLength,
  });

  final String? label;
  final AppTextSize? labelSize;
  final String hintText;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool obscureText;
  final bool? isOutline;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final int? maxLength;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
    const Color hintColor = AppPalette.textMuted; // muted/hint color
    final Color fillColor = cs.surfaceContainerHighest; // background
    final Color outlineColor = cs.outline; // normal border
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
      weight: AppTextWeight.medium,
      color: hintColor,
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
      hintText: widget.hintText,
      hintStyle: hintStyle,
      counterText: '',
      counterStyle: const TextStyle(fontSize: 0),

      floatingLabelBehavior: FloatingLabelBehavior.never,
      prefixIcon: widget.prefix != null
          ? Padding(
              padding: EdgeInsets.only(left: tok.gap.xs, right: tok.gap.sm),
              child: IconTheme(
                data: IconThemeData(
                  size: tok.iconLg,
                  color: (_focusNode.hasFocus && widget.enabled)
                      ? focusColor
                      : cs.onSurface.withOpacity(0.65),
                ),
                child: widget.prefix!,
              ),
            )
          : null,
      prefixIconConstraints: BoxConstraints(
        minWidth: widget.prefix != null ? tok.iconLg + tok.gap.sm : 0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: widget.isOutline ?? false ? outlineColor : cs.outlineVariant,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: focusColor, width: 1.5),
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

    // Input Formatters
    List<TextInputFormatter>? inputFormatters =
        widget.keyboardType == TextInputType.phone
        ? [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
        : [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppText(
            widget.label!,
            size: widget.labelSize ?? AppTextSize.s18,
            weight: AppTextWeight.semibold,
            color: tc.neutral,
          ),
          SizedBox(height: tok.gap.sm),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          textCapitalization: widget.textCapitalization,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          autofillHints: widget.autofillHints,
          style: textStyle,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          decoration: inputDecoration,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
