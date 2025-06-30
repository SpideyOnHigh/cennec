import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/dashboard/view/dashboard_home.dart';
import 'package:cennec/modules/dashboard/view/dashboard_messages.dart';
import 'package:cennec/modules/dashboard/view/dashboard_profile.dart';
import 'package:cennec/modules/dashboard/view/dashboard_recommendations.dart';
import 'package:cennec/modules/dashboard/view/dashboard_search.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  ValueNotifier<int> navIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  Widget bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: navIndex.value,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (value) {
        navIndex.value = value;
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(APPImages.icBottomHome, color: Colors.grey, width: Dimens.margin25, height: Dimens.margin25),
          label: "",
          activeIcon: Image.asset(APPImages.icBottomHome, color: Colors.white, width: Dimens.margin25, height: Dimens.margin25),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(APPImages.icBottomSearch, width: Dimens.margin25, height: Dimens.margin25),
          label: "",
          activeIcon: Image.asset(APPImages.icBottomSearch, color: Colors.white, width: Dimens.margin25, height: Dimens.margin25),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(APPImages.icBottomCennec, width: Dimens.margin30, height: Dimens.margin30),
          label: "",
          activeIcon: Image.asset(APPImages.icCennecBottom, width: Dimens.margin35, height: Dimens.margin35),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(APPImages.icBottomMsg, width: Dimens.margin25, height: Dimens.margin25),
          label: "",
          activeIcon: Image.asset(APPImages.icBottomMsg, color: Colors.white, width: Dimens.margin25, height: Dimens.margin25),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(APPImages.icBottomProfile, width: Dimens.margin25, height: Dimens.margin25),
          label: "",
          activeIcon: Image.asset(APPImages.icBottomProfile, color: Colors.white, width: Dimens.margin25, height: Dimens.margin25),
        ),
      ],
    );
  }

  List<Widget> currentScreen = [
    const DashboardHome(),
    const DashboardSearch(),
    const DashboardRecommendations(),
    const DashboardMessages(),
    const DashboardProfile(),
  ];

  Widget getBody() {
    return currentScreen[navIndex.value];
    /*  return IndexedStack(
      index: navIndex.value,
      children: const [
        DashboardHome(),
        DashboardSearch(),
        DashboardRecommendations(),
        DashboardMessages(),
        DashboardProfile(),
      ],
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [navIndex],
        builder: (context, values, child) {
          return Scaffold(
            bottomNavigationBar: SizedBox(
              height: Platform.isAndroid ? Dimens.margin70 : Dimens.margin95,
              child: bottomBar(),
            ),
            body: getBody(),
          );
        });
  }
}
