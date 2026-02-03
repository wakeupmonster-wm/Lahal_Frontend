import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

typedef ResendCallback = FutureOr<void> Function();

class ResendTimer extends StatefulWidget {
  /// countdown start in seconds (default 60)
  final int duration;

  /// called when user taps "Resend"
  final ResendCallback? onResend;

  /// optional: whether to start timer immediately
  final bool autoStart;

  const ResendTimer({
    super.key,
    this.duration = 60,
    this.onResend,
    this.autoStart = true,
  });

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  Timer? _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    if (widget.autoStart) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _remaining = widget.duration);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remaining <= 1) {
        t.cancel();
        setState(() => _remaining = 0);
      } else {
        setState(() => _remaining -= 1);
      }
    });
  }

  String _formattedSeconds(int s) {
    // if single digit show with leading zero, else normal
    if (s < 10) return '0$s';
    return '$s';
  }

  Future<void> _onResendTap() async {
    // restart timer immediately
    _start();
    if (widget.onResend != null) {
      await widget.onResend!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    // Colors & text sizes per your spec
    // "Didn't receive OTP?" -> size mid (use s16) and weight medium and color tx.neutral
    // The second line text uses same style but seconds/resend use tx.primary
    const labelStyleSize = AppTextSize.s12;
    const labelWeight = AppTextWeight.medium;

    return Column(
      children: [
        // Top label
        AppText(
          "Didn't receive OTP?",
          size: labelStyleSize,
          weight: labelWeight,
          color: tx.neutral,
        ),
        SizedBox(height: tok.gap.xs),
        // Second line: either "You can resend code in {SS} s" OR "You can resend code [Resend]"
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              "You can resend code in ",
              size: labelStyleSize,
              weight: labelWeight,
              color: tx.neutral,
            ),
            if (_remaining > 0) ...[
              // show timer with colored seconds + " s"
              AppText(
                " ${_formattedSeconds(_remaining)}",
                size: labelStyleSize,
                weight: labelWeight,
                // make the numeric part stand out — color the full substring for simplicity
                color: tx.link,
              ),
              AppText(
                " s",
                size: labelStyleSize,
                weight: labelWeight,
                color: tx.neutral,
              ),
            ] else ...[
              // show Resend button in place of timer
              GestureDetector(
                onTap: _onResendTap,
                behavior: HitTestBehavior.opaque,
                child: AppText(
                  "Resend",
                  size: labelStyleSize,
                  weight: labelWeight,
                  color: tx.link,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
