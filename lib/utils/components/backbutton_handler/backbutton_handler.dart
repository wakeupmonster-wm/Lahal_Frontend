import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

/// A widget that handles back button press with "press again to exit" logic
/// when there's no previous screen in the navigation stack.
class BackButtonHandler extends StatefulWidget {
  final Widget child;

  const BackButtonHandler({super.key, required this.child});

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      final cs = Theme.of(context).colorScheme;
      Fluttertoast.showToast(
        backgroundColor: cs.onSurface,
        msg: "Press again to exit",
        textColor: cs.surface,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false; // Don't exit
    }
    return true; // Exit the app
  }

  @override
  Widget build(BuildContext context) {
    // Check if we can pop (i.e., there's a previous screen)
    final canPop = context.canPop();

    // If we can pop, allow normal back navigation
    if (canPop) {
      return widget.child;
    }

    // If we can't pop (no previous screen), wrap with PopScope for exit logic
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        }
      },
      child: widget.child,
    );
  }
}
