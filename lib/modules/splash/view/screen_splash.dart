import 'package:cennec/modules/core/api_service/preference_helper.dart';

import '../../core/utils/common_import.dart';

/// This class is a stateful widget that creates a state object that is used to create a splash screen
/// `ScreenSplash` is a `StatefulWidget` that creates a `_ScreenSplashState` when it's built
class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      if (PreferenceHelper.getString(PreferenceHelper.userToken) != null && PreferenceHelper.getString(PreferenceHelper.userToken).toString().isNotEmpty &&
      (PreferenceHelper.getBool(PreferenceHelper.hasReadAboutUs) == true)) {
        printWrapped("-------${PreferenceHelper.getString(PreferenceHelper.userToken)}");
        NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesScreenDashboard,(route) => false,);
        // NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesScreenAboutUs,arguments: false,(route) => false,);
      }
      else if(PreferenceHelper.getString(PreferenceHelper.userToken) != null && PreferenceHelper.getString(PreferenceHelper.userToken).toString().isNotEmpty &&
          (PreferenceHelper.getBool(PreferenceHelper.hasReadAboutUs) == false))
        {
           NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesScreenAboutUs,arguments: false,(route) => false,);
        }
      else {
        NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesIntro, (route) => false);
      }
    });
    super.initState();
  }

  // void handleInitialNavigation() {
  //   if (PreferenceHelper.getString(PreferenceHelper.userToken) != null && PreferenceHelper.getString(PreferenceHelper.userToken).toString().isNotEmpty) {
  //     if ((PreferenceHelper.getBool(PreferenceHelper.userHaveReadAboutUs) == true) &&
  //         PreferenceHelper.getBool(PreferenceHelper.userHaveReadGuidelines) == true) {
  //       //if both accepted
  //       NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
  //         AppRoutes.routesScreenDashboard,
  //         (route) => false,
  //       );
  //     } else if (PreferenceHelper.getBool(PreferenceHelper.userHaveReadAboutUs) == false) {
  //       NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
  //         AppRoutes.routesScreenAboutUs,
  //         (route) => false,
  //       );
  //     }
  //     else if (PreferenceHelper.getBool(PreferenceHelper.userHaveReadGuidelines) == false) {
  //       NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
  //         AppRoutes.routesScreenCommunityGuidelines,
  //         (route) => false,
  //       );
  //     }
  //   } else {
  //     NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesLogin, (route) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget background = SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        APPImages.icSplash,
        fit: BoxFit.cover, // I thought this would fill up my Container but it doesn't
      ),
    );
    return SafeArea(
        child: Scaffold(
      body: background,
    ));
  }
}
