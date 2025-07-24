import 'package:cennec/modules/auth/bloc/logout_bloc/logout_bloc.dart';
import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:flutter/cupertino.dart';

import '../../core/utils/common_import.dart';

class DashboardProfile extends StatefulWidget {
  const DashboardProfile({super.key});

  @override
  State<DashboardProfile> createState() => _DashboardProfileState();
}

class _DashboardProfileState extends State<DashboardProfile> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Widget myProfileTexts(BuildContext context) {
    return Row(
      children: [
        Text(
          "My Profiles",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin25,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget navigationWithLogo() {
    return InkWell(
      // onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(Dimens.margin50)),
        height: Dimens.margin45,
        width: Dimens.margin45,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(APPImages.icBack),
        ),
      ),
    );
  }

  Widget textWidget(String text) {
    return Text(
      text,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  Widget getBody2() {
    return Stack(
      children: [
        Visibility(
            visible: (getUser().userData ?? UserData()).defaultProfilePic != null,
            replacement: Image.asset(
              APPImages.icDummyProfile, // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            ),
            child: Image.network(
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image is fully loaded
                }
                return const Center(
                  child: CommonLoadingAnimation(), // Show the loading animation
                );
              },
              (getUser().userData ?? UserData()).defaultProfilePic ?? '',
              // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            )),
        // Positioned(
        //     left: 20,
        //     top: 80,
        //     child: navigationWithLogo()),
        // Content
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Dimens.margin500,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimens.margin30), topRight: Radius.circular(Dimens.margin30)),
                color: Theme.of(context).scaffoldBackgroundColor),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: myProfileTexts(context),
                  ),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    // itemExtent: 30,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: textWidget('Edit Profile'),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.routesScreenEditProfile).then(
                            (value) {
                              if (value == true) {
                                setState(() {});
                              }
                            },
                          );
                        },
                        trailing: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(APPImages.icBottomProfile),
                        ),
                      ),
                      const Divider(
                        thickness: Dimens.margin1,
                      ),
                      ListTile(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.routesScreenPreferences),
                          title: textWidget('Connection Preferences'),
                          trailing: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Image.asset(APPImages.icConnectionPref),
                          )),
                      const Divider(
                        thickness: Dimens.margin1,
                      ),
                      ListTile(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.routesScreenSettings),
                        title: textWidget('Settings'),
                        trailing: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(APPImages.icSetting),
                        ),
                      ),
                      const Divider(
                        thickness: Dimens.margin1,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.routesScreenAboutUs, arguments: true);
                        },
                        title: textWidget('About Cennec'),
                      ),
                      const Divider(
                        thickness: Dimens.margin1,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.routesScreenFeedback);
                        },
                        title: textWidget('Feedback'),
                      ),
                      const Divider(
                        thickness: Dimens.margin1,
                      ),
                      ListTile(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoConfirmationDialog(
                              title: "Logout",
                              description: "Are you sure you want to logout?",
                              cancelText: "No",
                              confirmText: "Yes",
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                logoutEvent();
                              },
                            ),
                          );
                        },
                        title: textWidget('Log Out'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Bottom Navigation Bar
      ],
    );
  }

  Widget getBody() {
    final user = getUser().userData ?? UserData();
    final profileImage = user.defaultProfilePic ?? '';
    print("User : ${user.name}");
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Background profile image
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: profileImage.isNotEmpty
                  ? Image.network(
                      profileImage,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CommonLoadingAnimation());
                      },
                    )
                  : Image.asset(APPImages.icDummyProfile, fit: BoxFit.cover),
            ),

            // Name overlay
            Positioned(
              left: Dimens.margin20,
              bottom: Dimens.margin20,
              child: Text(
                user.username ?? 'User Name',
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin24,
                  Colors.white,
                  FontWeight.w700,
                ),
              ),
            )
          ],
        ),

        // Settings Panel
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(Dimens.margin20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              // color: Colors.red,
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(Dimens.margin30),
              //   topRight: Radius.circular(Dimens.margin30),
              // ),
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(Dimens.margin30),
              //   to
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: Dimens.margin16,vertical: Dimens.margin5),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildTile("Profile Preview & Edit", APPImages.icBottomProfile, () {
                    Navigator.pushNamed(context, AppRoutes.routesScreenEditProfile).then((value) {
                      if (value == true) setState(() {});
                    });
                  }),
                  _buildTile("Connection Preferences", APPImages.icConnectionPref, () {
                    Navigator.pushNamed(context, AppRoutes.routesScreenPreferences);
                  }),
                  _buildTile("Settings", APPImages.icSetting, () {
                    Navigator.pushNamed(context, AppRoutes.routesScreenSettings);
                  }),
                  _buildTile("About Cennec", null, () {
                    Navigator.pushNamed(context, AppRoutes.routesScreenAboutUs, arguments: true);
                  }),
                  _buildTile("Community Guidelines", null, () {
                    Navigator.pushNamed(context, AppRoutes.routesScreenCommunityGuidelines, arguments: true);
                  }),
                  _buildTile("Feedback", null, () {
                    Navigator.pushNamed(context, AppRoutes.routesScreenFeedback);
                  }),
                  _buildTile("Logout", null, () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoConfirmationDialog(
                        title: "Logout",
                        description: "Are you sure you want to logout?",
                        cancelText: "No",
                        confirmText: "Yes",
                        onCancel: () => Navigator.pop(context),
                        onConfirm: logoutEvent,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _divider() => const Divider(thickness: Dimens.margin1);

  Widget _buildTile(String title, String? iconPath, VoidCallback onTap) {
    return ListTile(
      minTileHeight: Dimens.margin45,
      contentPadding: EdgeInsets.symmetric(vertical: Dimens.margin2),
      onTap: onTap,
      title: textWidget(title),
      trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context).unfocus();
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        isLoading.value = state is LogoutLoading;
        if (state is LogoutResponse) {
          ToastController.showToast(context, state.modelLogoutSuccess.message ?? '', true);
          PreferenceHelper.clear();
          NavigatorKey.navigatorKey.currentState!
              .pushNamedAndRemoveUntil(AppRoutes.routesLogin, (route) => false);
        }
        if (state is LogoutFailure) {
          if (state.errorMessage.generalError!.isNotEmpty) {
            ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
          }
        }
      },
      child: SafeArea(
        child: IgnorePointer(
          ignoring: isLoading.value,
          child: Scaffold(
            body: Stack(
              children: [
                getBody(),
                Visibility(
                  visible: isLoading.value,
                  child: const CommonLoadingAnimation(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // logout event
  void logoutEvent() async {
    BlocProvider.of<LogoutBloc>(context).add(UserLogout(url: AppUrls.apiUserLogout));
  }
}
