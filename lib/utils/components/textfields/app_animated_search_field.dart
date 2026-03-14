import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class AppAnimatedSearchField extends StatefulWidget {
  const AppAnimatedSearchField({
    super.key,
    required this.hints,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.duration = const Duration(seconds: 3),
  });

  final List<String> hints;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Duration duration;

  @override
  State<AppAnimatedSearchField> createState() => _AppAnimatedSearchFieldState();
}

class _AppAnimatedSearchFieldState extends State<AppAnimatedSearchField> {
  late Timer _timer;
  int _currentIndex = 0;
  bool _showHint = true;
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(_handleTextChange);
    _showHint = _internalController.text.isEmpty;

    _timer = Timer.periodic(widget.duration, (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.hints.length;
        });
      }
    });
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {
        _showHint = _internalController.text.isEmpty;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    if (widget.controller == null) {
      _internalController.dispose();
    } else {
      _internalController.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tc = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final tp = Theme.of(context).extension<AppTypography>()!;

    final Color textColor = tc.neutral;
    const Color hintColor = AppPalette.textMuted;
    const Color iconColor = AppPalette.textMuted;
    final Color outlineColor = cs.outline.withValues(alpha: 0.3);
    final Color enabledBorderColor = cs.primary;
    final radius = tok.radiusMd;

    final textStyle = tp.style(
      context,
      size: AppTextSize.s14,
      weight: AppTextWeight.medium,
      color: textColor,
    );

    final hintStyle = tp.style(
      context,
      size: AppTextSize.s14,
      weight: AppTextWeight.medium,
      color: hintColor,
    );

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
          controller: _internalController,
          style: textStyle,
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          textInputAction: TextInputAction.search,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: tok.inset.fieldH,
              vertical: tok.inset.fieldV,
            ),
            hintText: "", // Empty hint, we'll animate our own
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: tok.gap.md, right: tok.gap.xxs),
              child: Icon(
                Iconsax.search_normal_1_outline,
                size: tok.iconSm,
                color: iconColor,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: tok.iconLg + tok.gap.sm,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: outlineColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: enabledBorderColor, width: 1.5),
            ),
          ),
        ),
        if (_showHint)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(
                    left: tok.iconSm + tok.gap.md + tok.gap.sm,
                  ),
                  child: ClipRect(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            final inAnimation = Tween<Offset>(
                              begin: const Offset(0.0, 1.0),
                              end: Offset.zero,
                            ).animate(animation);

                            final outAnimation = Tween<Offset>(
                              begin: const Offset(0.0, -1.0),
                              end: Offset.zero,
                            ).animate(animation);

                            return SlideTransition(
                              position:
                                  child.key ==
                                      ValueKey<String>(
                                        widget.hints[_currentIndex],
                                      )
                                  ? inAnimation
                                  : outAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      child: Container(
                        key: ValueKey<String>(widget.hints[_currentIndex]),
                        height: 48,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.hints[_currentIndex],
                          style: hintStyle,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
