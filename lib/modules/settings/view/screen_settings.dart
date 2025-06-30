import 'package:cennec/modules/auth/bloc/delete_profile_bloc/delete_profile_bloc.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/settings/bloc/edit_user_settings/edit_user_settings_bloc.dart';
import 'package:cennec/modules/settings/bloc/get_user_settings/get_user_setting_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../auth/model/model_login.dart';
import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import '../../core/utils/common_import.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  bool _notificationsEnabled = false;
  bool _showLocation = false;
  bool _showAge = false;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Widget settingsText(BuildContext context) {
    return Row(
      children: [
        Text(
          getTranslate(APPStrings.textSettings),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin32,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getUserSettings();
    super.initState();
  }

  Widget navigationWithLogo() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(Dimens.margin50)),
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
        Dimens.margin20,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getTranslate(title),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin22,
          Theme.of(context).hintColor,
          FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        getTranslate(title),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin20,
          Theme.of(context).colorScheme.onSecondary,
          FontWeight.w600,
        ),
      ),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget getBody() {
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
              (getUser().userData ?? UserData()).defaultProfilePic ?? '', // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            )),
        Positioned(left: 20, top: 80, child: navigationWithLogo()),
        // Content
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Dimens.margin500,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimens.margin30), topRight: Radius.circular(Dimens.margin30)),
                color: Theme.of(context).primaryColor),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: settingsText(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Notifications Section
                        _buildSectionTitle(APPStrings.textNotifications),
                        _buildSwitchTile(
                          title: APPStrings.textWhenSentMessage,
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                              editUserSettings();
                            });
                          },
                        ),
                        const Divider(
                          thickness: Dimens.margin2,
                        ),
                        // Privacy Section
                        _buildSectionTitle(APPStrings.textPrivacy),
                        _buildSwitchTile(
                          title: APPStrings.textShowLocation,
                          value: _showLocation,
                          onChanged: (value) {
                            setState(() {
                              _showLocation = value;
                              editUserSettings();
                            });
                          },
                        ),
                        _buildSwitchTile(
                          title: APPStrings.textShowAge,
                          value: _showAge,
                          onChanged: (value) {
                            setState(() {
                              _showAge = value;
                              editUserSettings();
                            });
                          },
                        ),
                        const Divider(
                          thickness: Dimens.margin2,
                        ),
                        // Security Section
                        _buildSectionTitle(APPStrings.textSecurity),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            getTranslate(
                              APPStrings.textChangePassword,
                            ),
                            style: getTextStyleFromFont(
                              AppFont.poppins,
                              Dimens.margin20,
                              Theme.of(context).colorScheme.onSecondary,
                              FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.routesScreenChangePassword);
                          },
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(getTranslate(APPStrings.textDeleteProfile),
                              style: getTextStyleFromFont(
                                AppFont.poppins,
                                Dimens.margin20,
                                Colors.red,
                                FontWeight.w600,
                              )),
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoConfirmationDialog(
                                title: getTranslate(APPStrings.textDeleteAccount),
                                description: getTranslate(APPStrings.textDeleteAccountConfirmation),
                                cancelText: getTranslate(APPStrings.textCancel),
                                confirmText: getTranslate(APPStrings.textOk),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  printWrapped("pressed key");
                                  deleteProfileEvent();
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isLoading],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<DeleteProfileBloc, DeleteProfileState>(
                listener: (context, state) {
                  isLoading.value = state is DeleteProfileLoading;
                    if (state is DeleteProfileFailure) {
                      if(state.errorMessage.generalError!.isNotEmpty)
                      {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                  }
                  if (state is DeleteProfileResponse) {
                    PreferenceHelper.clear();
                    NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesSplash, (route) => false);
                    ToastController.showToast(getNavigatorKeyContext(), 'User Logged out from device.', false);
                  }
                },
              ),
              BlocListener<GetUserSettingBloc, GetUserSettingState>(
                listener: (context, state) {
                  isLoading.value = state is GetUserSettingLoading;
                    if (state is GetUserSettingFailure) {
                      if(state.errorMessage.generalError!.isNotEmpty)
                      {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is GetUserSettingResponse) {
                    _notificationsEnabled = state.modelUserSettings.data?.isNotificationOnBool ?? false;
                    _showLocation = state.modelUserSettings.data?.isDisplayLocationBool ?? false;
                    _showAge = state.modelUserSettings.data?.isDisplayAgeBool ?? false;
                  }
                },
              ),
              BlocListener<EditUserSettingsBloc, EditUserSettingsState>(
                listener: (context, state) {
                  isLoading.value = state is EditUserSettingsLoading;
                    if (state is EditUserSettingsFailure) {
                      if(state.errorMessage.generalError!.isNotEmpty)
                      {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                  }
                  if (state is EditUserSettingsResponse) {
                    ToastController.showToast(context, state.modelEditSettingsResponse.message ?? '', true);
                    _notificationsEnabled = state.modelEditSettingsResponse.data?.isNotificationOn ?? false;
                    _showLocation = state.modelEditSettingsResponse.data?.isDisplayLocation ?? false;
                    _showAge = state.modelEditSettingsResponse.data?.isDisplayAge ?? false;
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Stack(
                children: [
                  IgnorePointer(ignoring: isLoading.value, child: getBody()),
                  Visibility(
                    visible: isLoading.value,
                    child: const Center(
                      child: CommonLoadingAnimation(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deleteProfileEvent()  {
    Map<String, dynamic> body = {AppConfig.paramUserId: getUser().userData?.id};
    BlocProvider.of<DeleteProfileBloc>(context).add(DeleteProfile(body: body, url: AppUrls.apiDeleteAccount));
  }

  void getUserSettings()  {
    // Map<String, dynamic> body = {AppConfig.paramUserId: getUser().userData?.id};
    BlocProvider.of<GetUserSettingBloc>(context).add(GetUserSettings(url: AppUrls.apiGetUserSettings(getUser().userData?.id ?? 0)));
  }

  void editUserSettings()  {
    Map<String, dynamic> body = {"user_id": (getUser().userData?.id ?? 0),
      "is_notification_on": _notificationsEnabled,
      "is_display_location": _showLocation,
      "is_display_age": _showAge};
    // Map<String, dynamic> body = {AppConfig.paramUserId: getUser().userData?.id};
    BlocProvider.of<EditUserSettingsBloc>(context).add(EditUserSettings(url: AppUrls.apiEditUserSettings, body: body));
  }
}
