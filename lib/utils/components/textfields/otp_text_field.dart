// lib/core/widgets/otp_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

typedef OtpCompleted = void Function(String otp);

class OtpField extends StatefulWidget {
  /// number of digits (defaults to 4)
  final int length;

  /// Called when user completed all digits
  final OtpCompleted? onCompleted;

  /// Optional initial value (e.g., autofill)
  final String? initialValue;

  /// Whether input is enabled
  final bool enabled;

  /// Optional style override for each box size
  final double? boxWidth;

  const OtpField({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.initialValue,
    this.enabled = true,
    this.boxWidth,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _completedEmitted = false;

  @override
  void initState() {
    super.initState();
    final len = widget.length;
    _controllers = List.generate(len, (i) => TextEditingController());
    _focusNodes = List.generate(len, (i) => FocusNode());
    if (widget.initialValue != null && widget.initialValue!.length >= len) {
      final v = widget.initialValue!;
      for (var i = 0; i < len; i++) {
        _controllers[i].text = v[i];
      }
      // notify after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkComplete());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isEmpty) {
      // user cleared the field — allow deletion handling elsewhere
      // also reset completed flag
      _completedEmitted = false;
      setState(() {});
      return;
    }

    // keep only last character (defensive)
    final ch = value.characters.last;
    _controllers[index].text = ch;
    // place caret at end
    _controllers[index].selection = TextSelection.fromPosition(
      const TextPosition(offset: 1),
    );

    // move focus forward if not last
    if (index + 1 < _focusNodes.length) {
      _focusNodes[index + 1].requestFocus();
    } else {
      // last box filled -> check complete
      _checkComplete();
      // hide keyboard (optional)
      _focusNodes[index].unfocus();
    }
    setState(() {});
  }

  void _onKey(KeyEvent ev, int index) {
    // Using KeyEvent to match KeyboardListener's signature
    if (ev is KeyDownEvent && ev.logicalKey == LogicalKeyboardKey.backspace) {
      final cur = _controllers[index];
      if (cur.text.isEmpty) {
        // move to previous
        if (index - 1 >= 0) {
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[index - 1].text.length),
          );
        }
      } else {
        // default behavior: the field will clear on backspace
        // reset completed flag because content changed
        _completedEmitted = false;
      }
    }
  }

  void _checkComplete() {
    final code = _controllers.map((c) => c.text).join();
    // ensure all controllers are non-empty
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);
    if (code.length == widget.length && allFilled) {
      if (!_completedEmitted) {
        _completedEmitted = true;
        widget.onCompleted?.call(code);
      }
    }
  }

  /// 🔥 ADD THIS
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _completedEmitted = false;
    // Put focus back to first box
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    final boxW = widget.boxWidth ?? (tok.iconLg * 2 + tok.gap.md);
    final textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: tx.neutral,
      letterSpacing: 1.2,
    );

    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (i) {
          return SizedBox(
            width: boxW,
            child: KeyboardListener(
              focusNode: FocusNode(skipTraversal: true),
              onKeyEvent: (ev) => _onKey(ev, i),
              child: TextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: textStyle,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: cs.surfaceContainerHighest,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: tok.inset.fieldV / 0.8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(tok.radiusMd),
                    borderSide: BorderSide(color: cs.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(tok.radiusMd),
                    borderSide: BorderSide(color: cs.primary, width: 1.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(tok.radiusMd),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
                // important: handle change manually to auto-advance
                onChanged: (v) => _onChanged(v, i),
                // support autofill for sms codes — on iOS/Android platforms that support it
                autofillHints: const [AutofillHints.oneTimeCode],
                textInputAction: i == widget.length - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                onSubmitted: (_) {
                  if (i == widget.length - 1) _checkComplete();
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
