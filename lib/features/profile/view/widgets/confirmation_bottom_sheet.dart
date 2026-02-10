import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/app_button.dart';

class ConfirmationBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final AppButtonVariant confirmVariant;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    required this.onConfirm,
    this.confirmVariant = AppButtonVariant.danger,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String confirmLabel,
    required VoidCallback onConfirm,
    AppButtonVariant confirmVariant = AppButtonVariant.danger,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationBottomSheet(
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        confirmVariant: confirmVariant,
      ),
    );
  }

  @override
  State<ConfirmationBottomSheet> createState() =>
      _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState extends State<ConfirmationBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  // Staggered Animations
  late Animation<Offset> _pullBarSlide;
  late Animation<double> _pullBarFade;

  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;

  late Animation<Offset> _messageSlide;
  late Animation<double> _messageFade;

  late Animation<Offset> _buttonsSlide;
  late Animation<double> _buttonsFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 1. Pull Bar (0-30%)
    _pullBarSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.3, curve: Curves.easeOutQuad),
          ),
        );
    _pullBarFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // 2. Title (10-40%)
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.1, 0.4, curve: Curves.easeOutQuad),
          ),
        );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
      ),
    );

    // 3. Message (20-50%)
    _messageSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.2, 0.5, curve: Curves.easeOutQuad),
          ),
        );
    _messageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    // 4. Buttons (30-60%)
    _buttonsSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.3, 0.6, curve: Curves.easeOutQuad),
          ),
        );
    _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>();
    final tx = Theme.of(context).extension<AppTextColors>();
    final cs = Theme.of(context).colorScheme;

    if (tok == null || tx == null) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(tok.gap.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(tok.radiusLg * 2),
          topRight: Radius.circular(tok.radiusLg * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pull Bar
          FadeTransition(
            opacity: _pullBarFade,
            child: SlideTransition(
              position: _pullBarSlide,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: tok.gap.lg),

          // Title
          FadeTransition(
            opacity: _titleFade,
            child: SlideTransition(
              position: _titleSlide,
              child: AppText(
                widget.title,
                size: AppTextSize.s18,
                weight: AppTextWeight.bold,
                color: tx.neutral,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: tok.gap.md),

          // Message
          FadeTransition(
            opacity: _messageFade,
            child: SlideTransition(
              position: _messageSlide,
              child: AppText(
                widget.subtitle,
                size: AppTextSize.s14,
                color: tx.subtle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: tok.gap.xl),

          // Buttons
          FadeTransition(
            opacity: _buttonsFade,
            child: SlideTransition(
              position: _buttonsSlide,
              child: Column(
                children: [
                  AppButton(
                    label: widget.confirmLabel,
                    onPressed: widget.onConfirm,
                    variant: widget.confirmVariant,
                    minWidth: double.infinity,
                  ),
                  SizedBox(height: tok.gap.sm),
                  AppButton(
                    label: AppStrings.cancel,
                    onPressed: () => context.pop(),
                    variant: AppButtonVariant.ghost,
                    minWidth: double.infinity,
                    fgColorOverride: tx.subtle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tok.gap.lg),
        ],
      ),
    );
  }
}
