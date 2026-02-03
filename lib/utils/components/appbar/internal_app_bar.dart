// lib/core/widgets/internal_app_bar.dart
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

/// Reusable Internal AppBar used across internal screens.
///
/// - left back icon (default Iconsax.arrow_left_outline)
/// - optional title (centered)
/// - optional progress (0..1). If progress != null the bar shows a linear progress
///   at top and title is hidden by default (you can still pass showTitleWhenProgress true).
/// - optional suffix widget on the right
/// - transparent background (no elevation)
class InternalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InternalAppBar({
    super.key,
    this.isBackEnabled = true,
    this.onBack,
    this.title,
    this.progress,
    this.suffix,
    this.showTitleWhenProgress = false,
    this.backgroundColor = Colors.transparent,
  });

  /// Is Back button enabled (default true)
  final bool isBackEnabled;

  /// Back button callback. If null, navigator.pop will be used if possible.
  final VoidCallback? onBack;

  /// Center title (18, bold). If null and progress == null, title area is empty.
  final String? title;

  /// Progress value 0..1. If not null, a thin linear progress bar is shown
  /// at top of app bar. By default when progress != null title is hidden.
  final double? progress;

  /// Optional right-side widget (menu, actions etc).
  final Widget? suffix;

  /// If true, title will still be shown even when progress is provided.
  final bool showTitleWhenProgress;

  /// AppBar background color (default transparent).
  final Color backgroundColor;

  /// OnBack callback. If null, navigator.pop will be used if possible.

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>();
    final tx = Theme.of(context).extension<AppTextColors>();
    final cs = Theme.of(context).colorScheme;
    final barHeight = tok?.appBarHeight ?? kToolbarHeight;
    final horizontalInset = tok?.inset.screenH ?? 16.0;
    final backIconSize = tok?.iconLg ?? 24.0;
    final width = MediaQuery.of(context).size.width;
    final height =
        (tok?.appBarHeight ?? kToolbarHeight) + (progress != null ? 4 : 0);

    // resolved title visibility rule
    final showTitle =
        (title != null) && (progress == null || showTitleWhenProgress);

    return Material(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main row
              SizedBox(
                height: barHeight - (progress != null ? 4.0 : 0.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back button
                      Visibility(
                        visible: isBackEnabled,
                        child: SizedBox(
                          width: backIconSize + 8,
                          height: backIconSize + 8,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: backIconSize,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Iconsax.arrow_left_outline),
                            onPressed:
                                onBack ??
                                () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }
                                },
                          ),
                        ),
                      ),

                      // Spacer left to center area
                      SizedBox(width: isBackEnabled ? 8 : 22),

                      // Title area - center aligned
                      progress != null
                          ? Expanded(
                              child: Center(
                                child: Container(
                                  width: width * 0.5,
                                  height: 12.0,
                                  // using theme primary for progress fill
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: cs.outline.withValues(
                                      alpha: 0.6,
                                    ), // background of bar track (transparent fallback)
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: (progress!.clamp(0.0, 1.0)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: cs.primary,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: showTitle
                                    ? AppText(
                                        title!,
                                        size: AppTextSize.s18,
                                        weight: AppTextWeight.bold,
                                        // Use neutral text color, fallback to colorScheme.onSurface
                                        color: tx?.neutral ?? cs.onSurface,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),

                      // Suffix area (right)
                      if (suffix != null)
                        SizedBox(
                          width: backIconSize + 8,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: suffix,
                          ),
                        )
                      else
                        // keep space so center looks visually centered
                        SizedBox(width: backIconSize + 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppTokens? get _safeToken {
    try {
      return WidgetsBinding.instance.rootElement != null
          ? Theme.of(
              WidgetsBinding.instance.renderViewElement!,
            ).extension<AppTokens>()
          : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Size get preferredSize {
    final tok = _safeToken;
    final progressHeight = progress != null ? 4.0 : 0.0;

    // Use token-based height
    final double base = tok?.appBarHeight ?? kToolbarHeight;

    // This will be used by Scaffold to reserve space.
    return Size.fromHeight(base + progressHeight);
  }
}
