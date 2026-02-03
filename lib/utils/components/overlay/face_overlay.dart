import 'package:flutter/material.dart';

/// Grey overlay with rounded-rect cutout (to match borderRadius 90)
class FaceOverlay extends StatelessWidget {
  const FaceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Window size
        final boxWidth = w * 0.75;
        final boxHeight = h * 0.40;
        final borderRadius = 80.0;

        // Position it higher (like selfie apps)
        final dx = (w - boxWidth) / 2;
        final dy = h * 0.22;

        final rect = Rect.fromLTWH(dx, dy, boxWidth, boxHeight);

        return CustomPaint(
          painter: FaceOverlayPainterRect(
            overlayColor: Colors.black.withOpacity(0.75),
            holeRect: rect,
            borderRadius: borderRadius,
            borderColor: cs.primary,
          ),
        );
      },
    );
  }
}

class FaceOverlayPainterRect extends CustomPainter {
  FaceOverlayPainterRect({
    required this.overlayColor,
    required this.holeRect,
    required this.borderRadius,
    required this.borderColor,
  });

  final Color overlayColor;
  final Rect holeRect;
  final double borderRadius;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final rrect = RRect.fromRectAndRadius(
      holeRect,
      Radius.circular(borderRadius),
    );

    final hole = Path()..addRRect(rrect);

    // Remove the rectangular window from overlay
    final combined = Path.combine(
      PathOperation.difference,
      overlay,
      hole,
    );

    // Draw semi-transparent dark overlay
    canvas.drawPath(
      combined,
      Paint()
        ..color = overlayColor
        ..style = PaintingStyle.fill,
    );

    // Draw border for face frame
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor.withOpacity(0.001)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant FaceOverlayPainterRect oldDelegate) {
    return overlayColor != oldDelegate.overlayColor ||
        holeRect != oldDelegate.holeRect ||
        borderRadius != oldDelegate.borderRadius ||
        borderColor != oldDelegate.borderColor;
  }
}
