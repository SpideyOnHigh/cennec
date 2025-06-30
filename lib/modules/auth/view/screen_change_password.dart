import 'package:cennec/modules/auth/bloc/change_or_set_new_password_bloc/change_or_set_new_pwd_bloc.dart';
import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

import '../../core/common/widgets/button.dart';

class ScreenChangePassword extends StatefulWidget {
  const ScreenChangePassword({super.key});

  @override
  State<ScreenChangePassword> createState() => _ScreenChangePasswordState();
}

class _ScreenChangePasswordState extends State<ScreenChangePassword> {
  // Password Text Editing Controllers
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ValueNotifier<String> errorOldPwd = ValueNotifier('');
  ValueNotifier<String> errorNewPwd = ValueNotifier('');
  ValueNotifier<String> errorCnfPwd = ValueNotifier('');
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> showOldPwd = ValueNotifier(false);
  ValueNotifier<bool> showNewPwd = ValueNotifier(false);
  ValueNotifier<bool> showCnfPwd = ValueNotifier(false);

  Widget navigationWithLogo() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(Dimens.margin16),
            child: Image.asset(
              APPImages.icBack,
              color: Theme.of(context).colorScheme.onSecondary, // Update with your logo path
              height: Dimens.margin30,
              width: Dimens.margin30,
            ),
          ),
        ),
        Center(
          child: Image.asset(
            APPImages.icLogoWithName, // Update with your logo path
            height: 80,
          ),
        ),
      ],
    );
  }

  Widget newPasswordText(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getTranslate(APPStrings.textNewPassword), // Update with localization key if needed
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin30,
          AppColors.colorDarkBlue,
          FontWeight.w700,
        ),
      ),
    );
  }

  Widget oldPasswordField(BuildContext context) {
    return BasePasswordTextFormField(
      controller: _oldPasswordController,
      hintText: getTranslate(APPStrings.textOldPassword), // Up
      onChange: () {
        if (errorOldPwd.value.isNotEmpty) {
          errorOldPwd.value = '';
        }
      },
      isShowPassword: !showOldPwd.value,
      pressShowPassword: ()
      {
        showOldPwd.value = !showOldPwd.value;
      },
      // ate with appropriate localization key
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget newPasswordField(BuildContext context) {
    return BasePasswordTextFormField(
      controller: _newPasswordController,
      hintText: getTranslate(APPStrings.textNewPassword),
      // Update with appropriate localization key
      onChange: () {
        if (errorNewPwd.value.isNotEmpty) {
          errorNewPwd.value = '';
        }
      },
      isShowPassword: !showNewPwd.value,
      pressShowPassword: ()
      {
        showNewPwd.value = !showNewPwd.value;
      },
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget confirmPasswordField(BuildContext context) {
    return BasePasswordTextFormField(
      controller: _confirmPasswordController,
      hintText: getTranslate(APPStrings.textConfirmPassword), //
      isShowPassword: !showCnfPwd.value,
      pressShowPassword: ()
      {
        showCnfPwd.value = !showCnfPwd.value;
      },
      onChange: () {
        if (errorCnfPwd.value.isNotEmpty) {
          errorCnfPwd.value = '';
        }
      }, // Update with appropriate localization key
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget updatePasswordButton(BuildContext context) {
    return CommonButton(
      isLoading: isLoading.value,
      text: getTranslate(APPStrings.textUpdatePassword), // Update with localization key
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        validate();
        // Navigator.pop(context);
      },
    );
  }

  Widget getBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Dimens.margin10,
        ),
        navigationWithLogo(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimens.margin30),
              newPasswordText(context),
              const SizedBox(height: Dimens.margin40),
              oldPasswordField(context),
              Visibility(
                  visible: errorOldPwd.value.isNotEmpty,
                  child: BaseTextFieldErrorIndicator(
                    errorText: errorOldPwd.value,
                  )),
              const SizedBox(height: Dimens.margin20),
              newPasswordField(context),
              Visibility(
                  visible: errorNewPwd.value.isNotEmpty,
                  child: BaseTextFieldErrorIndicator(
                    errorText: errorNewPwd.value,
                  )),
              const SizedBox(height: Dimens.margin20),
              confirmPasswordField(context),
              Visibility(
                  visible: errorCnfPwd.value.isNotEmpty,
                  child: BaseTextFieldErrorIndicator(
                    errorText: errorCnfPwd.value,
                  )),
              const SizedBox(height: Dimens.margin50),
              updatePasswordButton(context),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiValueListenableBuilder(
          valueListenables: [isLoading, errorOldPwd, errorNewPwd, errorCnfPwd,showOldPwd,showNewPwd,showCnfPwd],
          builder: (context, values, child) {
            return BlocListener<ChangeOrSetNewPwdBloc, ChangeOrSetNewPwdState>(
              listener: (context, state) {
                isLoading.value = state is ChangeOrSetNewPwdLoading;
                    if (state is ChangeOrSetNewPwdFailure) {
                      if(state.errorMessage.generalError!.isNotEmpty)
                      {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                      if(state.errorMessage.wrongPassword != null)
                      {
                        errorOldPwd.value = state.errorMessage.wrongPassword ?? '';
                      }
                      if(state.errorMessage.invalidPassword != null)
                      {
                        errorCnfPwd.value = state.errorMessage.invalidPassword ?? '';
                      }
                      if(state.errorMessage.samePassword != null)
                      {
                        errorCnfPwd.value = state.errorMessage.samePassword ?? '';
                      }
                      if(state.errorMessage.newPassword != null)
                      {
                        errorCnfPwd.value = state.errorMessage.newPassword ?? '';
                      }
                    }
                if(state is ChangeOrSetNewPwdResponse)
                  {
                    ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                    Navigator.pop(context);
                  }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: SingleChildScrollView(child: getBody(context)),
              ),
            );
          }),
    );
  }

  validate() {
    bool isValid = true;
    if (_oldPasswordController.text.isEmpty) {
      errorOldPwd.value = getTranslate(ValidationString.textValidateOldPwd);
      isValid = false;
    }
    if (_newPasswordController.text.isEmpty) {
      isValid = false;
      errorNewPwd.value = getTranslate(ValidationString.textValidateNewPwd);
    }
    if (_confirmPasswordController.text.isEmpty) {
      isValid = false;
      errorCnfPwd.value = getTranslate(ValidationString.textValidateCnfPwd);
    }
    if (_newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text != _confirmPasswordController.text) {
      isValid = false;
      errorCnfPwd.value = getTranslate(ValidationString.textValidatePwdNotMatches);
    }
    if (isValid) {
      changeEvent();
    }
  }

  void changeEvent()  {
    Map<String, dynamic> body = {AppConfig.paramCurrentPwd: _oldPasswordController.text.trim(), AppConfig.paramNewPwd: _confirmPasswordController.text.trim()};
    BlocProvider.of<ChangeOrSetNewPwdBloc>(context).add(ChangeOrSetNewPwd(body: body, url: AppUrls.apiChangePwd));
  }
}
