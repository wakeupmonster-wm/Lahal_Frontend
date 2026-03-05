import 'package:flutter/material.dart';

class AppShimmerFAB extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration shimmerDuration;
  final Duration tiltDuration;

  const AppShimmerFAB({
    super.key,
    required this.child,
    required this.onPressed,
    this.shimmerDuration = const Duration(seconds: 3),
    this.tiltDuration = const Duration(seconds: 2),
  });

  @override
  State<AppShimmerFAB> createState() => _AppShimmerFABState();
}

class _AppShimmerFABState extends State<AppShimmerFAB>
    with TickerProviderStateMixin {
  late AnimationController _tiltController;
  late AnimationController _shimmerController;
  late Animation<double> _tiltAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Tilt Animation: slight rotation back and forth
    _tiltController = AnimationController(
      duration: widget.tiltDuration,
      vsync: this,
    )..repeat(reverse: true);

    _tiltAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _tiltController, curve: Curves.easeInOut),
    );

    // Shimmer Animation: moving gradient
    _shimmerController = AnimationController(
      duration: widget.shimmerDuration,
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tiltController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_tiltController, _shimmerController]),
      builder: (context, child) {
        return Stack(
          children: [
            // Main Button
            GestureDetector(onTap: widget.onPressed, child: widget.child),

            // Shimmer Overlay
            Positioned.fill(
              child: IgnorePointer(
                child: ClipPath(
                  clipper: _FABOutlineClipper(),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.45, 0.5, 0.55, 1.0],
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.0),
                        ],
                        transform: _SlidingGradientTransform(
                          _shimmerAnimation.value,
                        ),
                      ).createShader(bounds);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        border: Border.all(color: Colors.white, width: 3.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

// Simple clipper that approximates a stadium/rounded rect shape for the shimmer
class _FABOutlineClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(100),
      ),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
