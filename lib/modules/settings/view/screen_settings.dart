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

  @override
  void initState() {
    getUserSettings();
    super.initState();
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[100],
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      title: Text(
        getTranslate(APPStrings.textSettings),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin20,
          Colors.black,
          FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              getTranslate(title),
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Colors.grey[600]!,
                FontWeight.w600,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getTranslate(title),
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin16,
              Colors.black,
              FontWeight.w500,
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    bool showArrow = true,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getTranslate(title),
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin16,
                textColor ?? Colors.black,
                FontWeight.w500,
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Notifications Section
                _buildSettingsCard(
                  title: APPStrings.textNotifications,
                  children: [
                    _buildSwitchTile(
                      title: APPStrings.textWhenSentMessage,
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                          editUserSettings();
                        });
                      },
                      isLast: true,
                    ),
                  ],
                ),

                // Privacy Section
                _buildSettingsCard(
                  title: APPStrings.textPrivacy,
                  children: [
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
                      isLast: true,
                    ),
                  ],
                ),

                // Security Section
                _buildSettingsCard(
                  title: APPStrings.textSecurity,
                  children: [
                    _buildActionTile(
                      title: APPStrings.textChangePassword,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.routesScreenChangePassword);
                      },
                    ),
                    _buildActionTile(
                      title: APPStrings.textDeleteProfile,
                      textColor: Colors.red,
                      showArrow: false,
                      isLast: true,
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

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
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
              backgroundColor: Colors.grey[100],
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
    BlocProvider.of<GetUserSettingBloc>(context).add(GetUserSettings(url: AppUrls.apiGetUserSettings(getUser().userData?.id ?? 0)));
  }

  void editUserSettings()  {
    Map<String, dynamic> body = {"user_id": (getUser().userData?.id ?? 0),
      "is_notification_on": _notificationsEnabled,
      "is_display_location": _showLocation,
      "is_display_age": _showAge};
    BlocProvider.of<EditUserSettingsBloc>(context).add(EditUserSettings(url: AppUrls.apiEditUserSettings, body: body));
  }
}