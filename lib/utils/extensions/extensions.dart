import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';

extension NavigationExtensions on BuildContext {
  void pushNamedRoute(String routeName) {
    Navigator.pushNamed(this, routeName);
  }
}

// This extension show all the logs on console
// Use it like this -> response.log();
extension Log on Object {
  void log([String tag = 'Log']) => dev.log(toString(), name: tag);
}

extension NavigationExtension on NavigatorState {
  Future pushScreen(Widget screen) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return screen;
        },
      ),
    );
  }
}

// -- This extension is used to Capitalize the first letter of a string
extension StringExtension on String {
  String get appCapitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
