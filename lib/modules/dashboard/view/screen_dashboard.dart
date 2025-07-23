import 'dart:io';
import 'package:cennec/modules/allPosts/view/screen_posts.dart';
import 'package:flutter/services.dart';

import '../../core/utils/common_import.dart';
import '../../search_posts/view/screen_find_connection.dart';
import '../../search_posts/view/screen_similar_and_interest.dart';
import 'dashboard_home.dart';
import 'dashboard_messages.dart';
import 'dashboard_mycennections.dart';
import 'dashboard_profile.dart';
import 'dashboard_recommendations.dart';
import 'dashboard_search.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  ValueNotifier<int> navIndex = ValueNotifier(0);

  final List<Widget> _screens = [
    const ScreenPosts(),
    // const DashboardHome(),
    const MyConnections(),
    const ScreenFindConnection(),
    const DashboardMessages(),
    const DashboardProfile(),
  ];

  void onItemTapped(int index) {
    navIndex.value = index;
  }

  Widget buildIcon(int index, String baseAssetPath) {
    final bool isSelected = navIndex.value == index;
    final String iconAsset = isSelected
        ? baseAssetPath.replaceFirst('.png', '_filled.png')
        : baseAssetPath;

    return IconButton(
      visualDensity: VisualDensity.standard,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onPressed: () => onItemTapped(index),
      icon: Image.asset(
        iconAsset,
        width: Dimens.margin24,
        height: Dimens.margin24,
      ),
    );
  }

  Widget buildFAB() {
    final bool isCenterSelected = navIndex.value == 2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: Dimens.margin72,
      height: Dimens.margin72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: isCenterSelected ? AppColors.menuPinkColor : Colors.grey,
          width: 5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () => onItemTapped(2),
        child: Image.asset(
          isCenterSelected
              ? APPImages.icCennecBottom // active colorful icon
              : APPImages.icCennecBottom, // default grey icon
          width: Dimens.margin35,
          height: Dimens.margin35,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return MultiValueListenableBuilder(
      valueListenables: [navIndex],
      builder: (context, values, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: _screens[navIndex.value],

          floatingActionButton: buildFAB(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: Dimens.margin8,
            elevation: 12,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: Platform.isAndroid ? Dimens.margin70 : Dimens.margin95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side
                    Row(
                      children: [
                        buildIcon(0, APPImages.iconHome),
                        const SizedBox(width: Dimens.margin24),
                        buildIcon(1, APPImages.iconCennections),
                      ],
                    ),

                    // Right side
                    Row(
                      children: [
                        buildIcon(3, APPImages.iconChat),
                        const SizedBox(width: Dimens.margin24),
                        buildIcon(4, APPImages.iconAccount),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
