import 'package:flutter/material.dart';

class IDCardOverlay extends StatelessWidget {
  const IDCardOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // ID card dimensions (slightly rectangular)
        final boxWidth = w * 0.85;
        final boxHeight = h * 0.30;
        final borderRadius = 16.0;

        final dx = (w - boxWidth) / 2;
        final dy = h * 0.28;

        final rect = Rect.fromLTWH(dx, dy, boxWidth, boxHeight);

        return CustomPaint(
          painter: _IDOverlayPainter(
            overlayColor: Colors.black.withOpacity(0.70),
            holeRect: rect,
            borderRadius: borderRadius,
            borderColor: cs.primary,
          ),
        );
      },
    );
  }
}

class _IDOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final Rect holeRect;
  final double borderRadius;
  final Color borderColor;

  _IDOverlayPainter({
    required this.overlayColor,
    required this.holeRect,
    required this.borderRadius,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final rrect = RRect.fromRectAndRadius(
      holeRect,
      Radius.circular(borderRadius),
    );
    final holePath = Path()..addRRect(rrect);

    final combined = Path.combine(PathOperation.difference, overlay, holePath);

    canvas.drawPath(
      combined,
      Paint()
        ..color = overlayColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = borderColor.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _IDOverlayPainter old) => true;
}
