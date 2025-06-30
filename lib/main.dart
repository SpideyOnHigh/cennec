import 'package:cennec/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'FirebaseNotificationHelper.dart';

/// `main()` is the entry point of the program
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('themeBox');
  FirebaseNotificationHelper().init(handler: firebaseMessagingBackgroundHandler);
  FlavorConfig(
    variables: {
      "env": "staging",
      "base": "https://cennec.staging9.com/",
      // "base": "http://192.168.9.161:8000/",
    },
  );
  runApp(const MyApp());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// make sure you call initializeApp before using other Firebase .
  printWrapped('RemoteMessage-- ${message.toMap()}');
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }

  // FirebaseNotificationHelper.getInstance().showNotification(message);
}
