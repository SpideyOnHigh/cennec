import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

/// `main()` is the entry point of the program
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('themeBox');
  FlavorConfig(
    variables: {
      "env": "dev",
      "base": "https://9f2e-2405-201-2011-b920-1596-3811-8666-527e.ngrok-free.app/",
      "front_end_base": "https://abcdev.staging9.com/"
    },
  );
  runApp(const MyApp());
}
