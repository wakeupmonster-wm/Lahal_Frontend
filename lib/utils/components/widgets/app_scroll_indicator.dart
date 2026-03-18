import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';

class AppScrollIndicator extends StatefulWidget {
  final ScrollController controller;

  const AppScrollIndicator({super.key, required this.controller});

  @override
  State<AppScrollIndicator> createState() => _AppScrollIndicatorState();
}

class _AppScrollIndicatorState extends State<AppScrollIndicator> {
  double _progress = 0;
  bool _isVisible = false;
  bool _isScrolling = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (!widget.controller.hasClients) return;

    final maxScroll = widget.controller.position.maxScrollExtent;
    final currentScroll = widget.controller.offset;

    setState(() {
      _progress = (maxScroll <= 0)
          ? 0
          : (currentScroll / maxScroll).clamp(0.0, 1.0);
      _isVisible = true;
      _isScrolling = true;
    });

    // Reset hide timer
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
          _isScrolling = false;
        });
      }
    });

    // Reset scrolling thickness after a short delay if no more scroll events
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted &&
          widget.controller.position.isScrollingNotifier.value == false) {
        setState(() {
          _isScrolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 12, // Hit area
        margin: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, _progress * 2 - 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                width: _isScrolling ? 8 : 4,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _isScrolling
                      ? [
                          BoxShadow(
                            color: AppColor.primaryColor.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
