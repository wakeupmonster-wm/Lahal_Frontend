import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CalulateFormHeight {
  // -- Get Field Height
  static double _getFieldHeight(GlobalKey<FormFieldState> key) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  // -- Calculate Form Height
  static Future<void> calculateFormHeight(
    List<GlobalKey<FormFieldState>> keys,
    RxDouble totalHeight,
    double extraHeight,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      double height = keys.map(_getFieldHeight).reduce((value, element) => value + element);
      totalHeight.value = height + extraHeight;
    });
  }
}
