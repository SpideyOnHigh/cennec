import 'package:flutter/material.dart';

/// A class that is used to store the state of the navigator.
/// The NavigatorKey class is a class that contains two static final variables, navigatorKey and
/// dropDownKey, which are both GlobalKey objects
class NavigatorKey {
  static final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigator');
  static final dropDownKey = GlobalKey(debugLabel: 'dropDown');
}
