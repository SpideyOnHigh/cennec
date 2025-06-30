import 'package:cennec/modules/core/api_service/bloc_generator.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/app_localizations.dart';
import 'package:cennec/modules/core/utils/route_generator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'modules/core/AppNavObserver.dart';
import 'modules/core/theme_cubit/theme_cubit.dart';
import 'modules/core/utils/common_import.dart';

/// Used by [MyApp] StatefulWidget for init of app
///[MultiProvider] A provider that merges multiple providers into a single linear widget tree.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: const MaterialAppWidget(),
    );
  }
}

///[MaterialAppWidget] This class use to Material App Widget
class MaterialAppWidget extends StatefulWidget {
  const MaterialAppWidget({Key? key}) : super(key: key);

  static ValueNotifier<Locale> notifier =
      ValueNotifier<Locale>(const Locale(APPStrings.languageEn));

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

///[MyAppState] This class use to My App State
class MyAppState extends State<MaterialAppWidget> {
  ApiProvider apiProvider = ApiProvider();
  http.Client client = http.Client();
  static ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  late StreamSubscription<ConnectivityResult> onConnectivityChanged;



  ValueNotifier<bool> isDrawerClose = ValueNotifier<bool>(false);

  static bool themeChangeValue = false;

  @override
  void initState() {
    init();
    themeChangeValue = getThemeData(def: false);

    setThemeData(context, isDark: themeChangeValue);

    super.initState();
  }
  Future<void> init() async {
    isConnected.value = await checkConnectivity();
    onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult event) async {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        isConnected.value = true;
        themeChangeValue = getThemeData(def: false);
        if ((NavigatorKey.navigatorKey.currentContext ??
            NavigatorKey.navigatorKey.currentState?.context) ==
            null) {
          await Future.delayed(const Duration(milliseconds: 500))
              .whenComplete(() {
            setThemeData(getNavigatorKeyContext(), isDark: themeChangeValue);
          });
        } else {
          setThemeData(getNavigatorKeyContext(), isDark: themeChangeValue);
        }
      } else {
        isConnected.value = false;
      }
    });
    PreferenceHelper.load().whenComplete(() {
      updateLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    addingMobileUiStyles(context);
    return ValueListenableBuilder<Locale>(
      builder: (BuildContext context, Locale newLocale, Widget? child) {
        return MultiProvider(
          providers: BlocGenerator.generateBloc(apiProvider, client),
          child: MultiValueListenableBuilder(
              valueListenables: [isDrawerClose,getCurrentChatUserId,isConnected],
              builder: (BuildContext context, values, Widget? child) {
                return BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
                      child: MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: APPStrings.appName,
                        theme: getTheme(state.themeData, context),
                        locale: newLocale,
                        localizationsDelegates:  const [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          AppLocalizations.delegate
                        ],
                        supportedLocales: const [
                          Locale(APPStrings.languageEn, ''), // English
                        ],
                        debugShowMaterialGrid: false,
                        showSemanticsDebugger: false,
                        showPerformanceOverlay: false,
                        navigatorKey: NavigatorKey.navigatorKey,
                        navigatorObservers: [AppNavObserver()],
                        // home:  ScreenSplash(),
                        onGenerateRoute: RouteGenerator.generateRoute,
                      ),
                    );
                  },
                );
              }),
        );
      },
      valueListenable: MaterialAppWidget.notifier,
    );
  }

  ///[getTheme] This method use to ThemeData of current app
  ThemeData getTheme(theme, BuildContext context) {
    if (theme == 'dark') {
      return darkThemeData(context);
    } else if (theme == 'light') {
      return lightThemeData(context);
    } else if (Hive.box('themeBox').get('themeData') != null) {
      return Hive.box('themeBox').get('themeData')
          ? darkThemeData(context)
          : lightThemeData(context);
    } else {
      return lightThemeData(context);
    }
  }

  ///[lightThemeData] This method use to ThemeData of light Theme Data
  ThemeData lightThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
      primaryColor: Colors.white,
      useMaterial3: false,
      hintColor: AppColors.colorDarkPurple,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.colorDarkBlue, // Random color
        onPrimary: AppColors.colorBlack, // White
        secondary: AppColors.colorGreyLight, // Random color
        onSecondary: AppColors.colorGreyLight1, // Black
        error: Color(0xFFF44336), // Random color
        onError: Color(0xFFFFFFFF), // White
        surface: Color(0xFFFFFFFF), // White
        onSurface: Color(0xFF000000), // Black
        background: Color(0xFFE0E0E0), // Light grey
        onBackground: Color(0xFF000000),),
      // primaryColorLight: ,
      // backgroundColor: AppColors.colorWhite,
      canvasColor: AppColors.colorGrey,
      cardColor: AppColors.colorBlack,
      indicatorColor: AppColors.colorPrimary2,
      primaryTextTheme: const TextTheme(
        // headline1: AppFont.regularBlack,
        // headline2: AppFont.colorWhite,
        // headline3: AppFont.colorRed,
      ),
      scaffoldBackgroundColor: AppColors.colorOffWhite,
    );
  }

  ///[darkThemeData] This method use to ThemeData of dark Theme Data
  ThemeData darkThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
      primaryColor: AppColors.colorPrimary,
      // backgroundColor: AppColors.colorBlack,
      canvasColor: AppColors.colorGrey,
      cardColor: AppColors.colorWhite,
      primaryTextTheme: const TextTheme(
        // headline1: AppFont.colorWhite,
        // headline2: AppFont.regularBlack,
        // headline3: AppFont.colorGreen,
      ),
      scaffoldBackgroundColor: Colors.black,
    );
  }

  /// Used by [SystemChrome] of app
  void addingMobileUiStyles(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.transparent
            : AppColors.colorWhite,
        /* set Status bar color in Android devices. */

        statusBarIconBrightness: Brightness.dark,
        /* set Status bar icons color in Android devices.*/
        statusBarBrightness: Brightness.dark));
  }

  ///[setTimer] This method use to set Timer
  void setTimer() {
    Timer(const Duration(milliseconds: 200), () async {
      isDrawerClose.value = false;
    });
  }

  /// It updates the language of the app.
  void updateLanguage() async {
    if (PreferenceHelper.getString(PreferenceHelper.userLanguage) != null &&
        PreferenceHelper.getString(PreferenceHelper.userLanguage)!.isNotEmpty) {
      MaterialAppWidget.notifier.value =
          PreferenceHelper.getString(PreferenceHelper.userLanguage) == APPStrings.languageEn
              ? const Locale(PreferenceHelper.userLanguage)
              : const Locale(APPStrings.languageAr);
    }
  }
}
