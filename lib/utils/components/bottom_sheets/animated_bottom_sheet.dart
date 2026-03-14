import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';

/// A reusable base class for animated bottom sheets with staggered children.
class AppAnimatedBottomSheet extends StatefulWidget {
  final List<Widget> children;
  final bool showPullBar;
  final double staggerDelay;

  const AppAnimatedBottomSheet({
    super.key,
    required this.children,
    this.showPullBar = true,
    this.staggerDelay = 0.05, // 50ms stagger between each child
  });

  @override
  State<AppAnimatedBottomSheet> createState() => _AppAnimatedBottomSheetState();
}

class _AppAnimatedBottomSheetState extends State<AppAnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 80 + (widget.children.length * 80)),
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
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showPullBar) ...[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: tok.gap.lg),
          ],
          ...List.generate(widget.children.length, (index) {
            final start = index * widget.staggerDelay;
            final end = start + 0.4; // Animation lasts 40% of total duration

            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animController,
                  curve: Interval(
                    start.clamp(0.0, 1.0),
                    end.clamp(0.0, 1.0),
                    curve: Curves.easeIn,
                  ),
                ),
              ),
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animController,
                        curve: Interval(
                          start.clamp(0.0, 1.0),
                          end.clamp(0.0, 1.0),
                          curve: Curves.easeOutQuad,
                        ),
                      ),
                    ),
                child: widget.children[index],
              ),
            );
          }),
        ],
      ),
    );
  }
}
