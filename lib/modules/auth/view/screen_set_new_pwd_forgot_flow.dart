import 'package:cennec/modules/auth/bloc/change_or_set_new_password_bloc/change_or_set_new_pwd_bloc.dart';
import 'package:cennec/modules/auth/model/model_sign_up_data_transfer.dart';
import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';

class ScreenSetNewPassword extends StatefulWidget {
  final ModelSignUpDataTransfer modelSignUpDataTransfer;
  const ScreenSetNewPassword({super.key, required this.modelSignUpDataTransfer});

  @override
  State<ScreenSetNewPassword> createState() => _ScreenSetNewPasswordState();
}

class _ScreenSetNewPasswordState extends State<ScreenSetNewPassword> {
  // Password Text Editing Controllers
  final TextEditingController _choosePasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ValueNotifier<String> errorChoosePwd = ValueNotifier('');
  ValueNotifier<String> errorCnfPwd = ValueNotifier('');
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueNotifier<bool> showChoosePwd = ValueNotifier(false);
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

  Widget changePasswordText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        getTranslate(APPStrings.textResetPassword),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin40,
          AppColors.colorDarkBlue,
          FontWeight.w700,
        ),
      ),
    );
  }

  Widget choosePasswordField(BuildContext context) {
    return BasePasswordTextFormField(
      controller: _choosePasswordController,
      isShowPassword: !showChoosePwd.value,
      pressShowPassword: () {
        showChoosePwd.value = !showChoosePwd.value;
      },
      onChange: () {
        if (errorChoosePwd.value.isNotEmpty) {
          errorChoosePwd.value = '';
        }
      },
      hintText: getTranslate(APPStrings.textNewPwd),
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
      hintText: getTranslate(APPStrings.textReEnterNewPwd),
      isShowPassword: !showCnfPwd.value,
      pressShowPassword: () {
        showCnfPwd.value = !showCnfPwd.value;
      },
      onChange: () {
        if (errorCnfPwd.value.isNotEmpty) {
          errorCnfPwd.value = '';
        }
      },
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget nextButton(BuildContext context) {
    return CommonButton(
      text: getTranslate(APPStrings.textSubmit),
      backgroundColor: Theme.of(context).colorScheme.primary,
      isLoading: isLoading.value,
      onTap: () {
        validate();
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
              changePasswordText(context),
              const SizedBox(height: Dimens.margin40),
              choosePasswordField(context),
              Visibility(
                  visible: errorChoosePwd.value.isNotEmpty,
                  child: BaseTextFieldErrorIndicator(errorText: errorChoosePwd.value,)),
              const SizedBox(height: Dimens.margin20),
              confirmPasswordField(context),
              Visibility(
                  visible: errorCnfPwd.value.isNotEmpty,
                  child: BaseTextFieldErrorIndicator(errorText: errorCnfPwd.value,)),
              const SizedBox(height: Dimens.margin50),
              nextButton(context),
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
            valueListenables: [isLoading, showCnfPwd, showChoosePwd, errorChoosePwd, errorCnfPwd],
            builder: (context, values, child) {
              return BlocListener<ChangeOrSetNewPwdBloc, ChangeOrSetNewPwdState>(
                listener: (context, state) {
                  isLoading.value = state is ChangeOrSetNewPwdLoading;

                    if (state is ChangeOrSetNewPwdFailure) {
                      if(state.errorMessage.generalError!.isNotEmpty)
                      {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                      if(state.errorMessage.invalidPassword != null)
                        {
                          errorCnfPwd.value = state.errorMessage.invalidPassword ?? '';
                        }
                  }
                  if(state is ChangeOrSetNewPwdResponse)
                  {
                    ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.routesLogin,
                          (route) => false,
                    );
                  }
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: SingleChildScrollView(child: getBody(context)),
                ),
              );
            }));
  }

  validate() {
    bool isValid = true;

    if (_choosePasswordController.text.isEmpty) {
      isValid = false;
      errorChoosePwd.value = getTranslate(ValidationString.textValidateChoosePwd);
    }
    if (_confirmPasswordController.text.isEmpty) {
      isValid = false;
      errorCnfPwd.value = getTranslate(ValidationString.textValidateCnfPwd);
    }
    if (_choosePasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _choosePasswordController.text != _confirmPasswordController.text) {
      isValid = false;
      errorCnfPwd.value = getTranslate(ValidationString.textValidatePwdNotMatches);
    }
    if (isValid) {
      changeEvent();
    }
  }

  void changeEvent()  {
    Map<String, dynamic> body = {
      AppConfig.paramEmail: widget.modelSignUpDataTransfer.email,
      AppConfig.paramOtp: widget.modelSignUpDataTransfer.code,
      AppConfig.paramPassword: _choosePasswordController.text.trim(),
      AppConfig.paramCnfPassword: _confirmPasswordController.text.trim()
    };
    BlocProvider.of<ChangeOrSetNewPwdBloc>(context).add(ResetPwd(body: body, url: AppUrls.apiResetPwd));
  }

}
