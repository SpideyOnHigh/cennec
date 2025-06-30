import 'package:flutter/foundation.dart';

/// > PrintLog is a class that prints logs to the console
class PrintLog {
  static printLog(message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
