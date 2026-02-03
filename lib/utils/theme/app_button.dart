import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';

enum AppButtonVariant { primary, tonal, outline, ghost, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
    this.trailing,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.disabled = false,
    this.minWidth,
    this.forceUppercase = false,
    // optional overrides (if you want to override token values per-instance)
    this.heightOverride,
    this.radiusOverride,
    this.fgColorOverride,
    this.bgColorOverride,
    this.borderColorOverride,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final AppButtonVariant variant;
  final bool loading;
  final bool disabled;
  final double? minWidth;
  final bool forceUppercase;
  final Color? fgColorOverride;
  final Color? bgColorOverride;

  // optional overrides
  final double? heightOverride;
  final double? radiusOverride;
  final Color? borderColorOverride;

  // design baseline for responsive scale
  static const double _designWidth = 430.0;

  Color _overlayForBrightness(Brightness b) => b == Brightness.light
      ? Colors.white.withValues(alpha: 0.3)
      : Colors.black.withOpacity(0.10);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    // try to read AppTokens from Theme extensions (may throw if not present)
    AppTokens? tok;
    try {
      tok = Theme.of(context).extension<AppTokens>();
    } catch (_) {
      tok = null;
    }

    // responsive scale factor based on screen width (kept same clamp as tokens factory)
    final width = MediaQuery.of(context).size.width;
    final widthScale = (width / _designWidth).clamp(0.90, 1.20);

    // derive base size using tokens when available, otherwise sensible defaults
    final defaultHeight =
        heightOverride ??
        (tok != null ? (56.0 * widthScale) : (56.0 * widthScale));
    final horizontalPadding = tok != null
        ? (tok.inset.card * 0.9) * widthScale
        : 24.0 * widthScale;
    final fontSize = tok != null ? (16.0 * widthScale) : (16.0 * widthScale);
    final iconSize = tok != null ? tok.iconSm * widthScale : 20.0 * widthScale;
    final radius = radiusOverride ?? 100;

    // variant colors (prefers ColorScheme for semantic mapping)
    Color bg;
    Color fg;
    Color borderColor = Colors.transparent;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = cs.primary;
        fg = cs.onPrimary;
        break;
      case AppButtonVariant.tonal:
        bg = cs.secondaryContainer;
        fg = cs.secondary;
        break;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = cs.primary;
        borderColor = cs.outline;
        break;
      case AppButtonVariant.ghost:
        bg = Colors.transparent;
        fg = cs.onSurface;
        break;
      case AppButtonVariant.danger:
        bg = AppPalette.error; // semantic error color from palette
        fg = Colors.white;
        break;
    }

    final effectiveOnPressed = (loading || disabled) ? null : onPressed;

    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: effectiveOnPressed == null
          ? cs.onSurface.withValues(alpha: 0.4)
          : fgColorOverride ?? fg,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(size: iconSize, color: fg),
            child: leading!,
          ),
          SizedBox(width: tok?.gap.sm ?? 8),
        ],
        Flexible(
          child: Opacity(
            opacity: loading
                ? 0.0
                : 1.0, // hide text while loading (per your ask)
            child: Text(
              forceUppercase ? label.toUpperCase() : label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: textStyle,
            ),
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: tok?.gap.sm ?? 8),
          IconTheme(
            data: IconThemeData(size: iconSize, color: fg),
            child: trailing!,
          ),
        ],
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: defaultHeight,
        minWidth: minWidth ?? 0,
      ),
      child: Material(
        color:
            (variant == AppButtonVariant.outline ||
                variant == AppButtonVariant.ghost)
            ? Colors.transparent
            : bgColorOverride ?? bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColorOverride ?? borderColor),
        ),
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: BorderRadius.circular(radius),
          splashColor: fg.withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // padded content area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SizedBox(
                  height: defaultHeight,
                  width: double.infinity,
                  child: Center(child: content),
                ),
              ),

              // fade overlay when loading or disabled (10%)
              if (loading || disabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      color: _overlayForBrightness(brightness),
                    ),
                  ),
                ),

              // spinner shown when loading, centered
              if (loading)
                Center(
                  child: SizedBox(
                    width: defaultHeight * 0.48,
                    height: defaultHeight * 0.48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.4 * (widthScale),
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
