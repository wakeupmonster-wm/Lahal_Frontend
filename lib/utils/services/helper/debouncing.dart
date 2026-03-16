import 'dart:async';

import 'package:flutter/material.dart';

class AppDebouncer {
  final int milliseconds;
  Timer? _timer;
  DateTime? _lastRunTime;

  AppDebouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      _lastRunTime = DateTime.now();
      action();
    });
  }

  /// Check if debouncer is currently running (waiting to execute)
  bool get isRunning => _timer?.isActive ?? false;

  /// Get remaining time until next execution can happen
  Duration get remainingTime {
    if (_timer?.isActive != true || _lastRunTime == null) {
      return Duration.zero;
    }

    final elapsed = DateTime.now().difference(_lastRunTime!);
    final remaining = Duration(milliseconds: milliseconds) - elapsed;

    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Cancel any pending execution
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
