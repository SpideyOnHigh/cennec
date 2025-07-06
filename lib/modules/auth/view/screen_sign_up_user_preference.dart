import 'package:cennec/modules/auth/bloc/sign_up_details_fill_bloc/sign_up_details_bloc.dart';
import 'package:cennec/modules/auth/model/model_sign_up_data_transfer.dart';
import 'package:cennec/modules/core/common/widgets/base_date_picker.dart';
import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/gender_dropdown.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:flutter/services.dart';
import '../../core/common/widgets/base_rounded_corner_widget.dart';
import '../../core/common/widgets/common_password_form_field.dart';
import '../../core/common/widgets/common_text_field.dart';
import '../../core/utils/common_import.dart';

class ScreenSignUpUserPreference extends StatefulWidget {
  final ModelSignUpDataTransfer modelSignUpDataTransfer;
  const ScreenSignUpUserPreference({super.key, required this.modelSignUpDataTransfer});

  @override
  State<ScreenSignUpUserPreference> createState() => _ScreenSighInUserPreferenceState();
}

class _ScreenSighInUserPreferenceState extends State<ScreenSignUpUserPreference> {
  // controllers
  TextEditingController userNameController = TextEditingController();
  TextEditingController choosePwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  ValueNotifier<bool> showChoosePwd = ValueNotifier(false);
  ValueNotifier<bool> showConfirmPwd = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  // errorShowers
  ValueNotifier<String> errorUserName = ValueNotifier('');
  ValueNotifier<String> errorChoosePwd = ValueNotifier('');
  ValueNotifier<String> errorConfirmPwd = ValueNotifier('');
  ValueNotifier<String> errorDOB = ValueNotifier('');
  ValueNotifier<String> errorGender = ValueNotifier('');

  Widget logo() {
    return Image.asset(
      APPImages.icLogoWithName, // Update with your logo path
      height: 80,
    );
  }

  Widget signUpText(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textSignUp).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin40,
        AppColors.colorDarkBlue,
        FontWeight.w700,
      ),
    );
  }

  Widget displayNameField(BuildContext context) {
    return CommonTextFormField(
      controller: userNameController,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      onChanged: (_) {
        if (errorUserName.value.isNotEmpty) {
          errorUserName.value = '';
        }
      },
      label: getTranslate(APPStrings.textDisplayName),
    );
  }

  Widget choosePasswordField(BuildContext context) {
    return CommonPasswordTextFormField(
      label: getTranslate(APPStrings.textChoosePassword),
      controller: choosePwdController,
      isShowPassword: showChoosePwd.value,
      onToggleVisibility: () {
        showChoosePwd.value = !showChoosePwd.value;
      },
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      errorText: errorChoosePwd.value,
      onChanged: (val) {
        if (errorChoosePwd.value.isNotEmpty) {
          errorChoosePwd.value = '';
        }
      },
    );
  }

  Widget confirmPasswordField(BuildContext context) {
    return CommonPasswordTextFormField(
      label: getTranslate(APPStrings.textConfirmPassword),
      controller: confirmPwdController,
      isShowPassword: showConfirmPwd.value,
      onToggleVisibility: () {
        showConfirmPwd.value = !showConfirmPwd.value;
      },
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      errorText: errorConfirmPwd.value,
      onChanged: (val) {
        if (errorConfirmPwd.value.isNotEmpty) {
          errorConfirmPwd.value = '';
        }
      },
    );
  }

  String? dateText;
  DateTime? pickedDateTime;
  Widget datePickerField(BuildContext context) {
    // todo change initial date time
    return BaseDatePicker(
      label: getTranslate(APPStrings.textDateOfBirth),
      initialDateTime: pickedDateTime,
      onDateTimeChanged: (p0) {
        setState(() {
          pickedDateTime = p0;
          dateText = "${p0.month.toString().padLeft(2, '0')}-${p0.day.toString().padLeft(2, '0')}-${p0.year}";
        });
        if (errorDOB.value.isNotEmpty) {
          errorDOB.value = '';
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

  GenderModel gender = GenderModel();
  Widget genderPickerField(BuildContext context) {
    // todo change initial date time
    return GenderDropdown(
      hintText:  getTranslate(APPStrings.textGender),
      onChanged: (p0) {
        setState(() {
          printWrapped("${p0.type}");
          gender = p0;
        });
        if (errorGender.value.isNotEmpty) {
          errorGender.value = '';
        }
      },
    );
  }

  /* Widget signUpButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: Dimens.margin50,
      child: ElevatedButton(
        onPressed: () {
           Navigator.pushNamed(context, AppRoutes.routesScreenAboutUs);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorDarkBlue,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          getTranslate(APPStrings.textSignUp),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).primaryColor,
            FontWeight.w600,
          ),
        ),
      ),
    );
  } */

  Widget signUpButton(BuildContext context) {
    return CommonButton(
      isLoading: isLoading.value,
      text: getTranslate(APPStrings.textNext),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        validate();
        // Navigator.pushNamed(context, AppRoutes.routesScreenAboutUs, arguments: false);
      },
    );
  }

  Widget alreadyAccountText(BuildContext context) {
    return Center(
      child: Text(
        getTranslate(APPStrings.textHaveAccount),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.secondary,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget tapToSignIn(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.routesLogin,
            (route) => false,
          );
        },
        child: Text(
          getTranslate(APPStrings.textTapToSignIn),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin22,
            Theme.of(context).colorScheme.onSecondary,
            FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          displayNameField(context),
          Visibility(
            visible: errorUserName.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: errorUserName.value,
            ),
          ),
          const SizedBox(height: 20),
          choosePasswordField(context),
          Visibility(
            visible: errorChoosePwd.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: errorChoosePwd.value,
            ),
          ),
          const SizedBox(height: 20),
          confirmPasswordField(context),
          Visibility(
            visible: errorConfirmPwd.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: errorConfirmPwd.value,
            ),
          ),
          const SizedBox(height: 20),
          datePickerField(context),
          Visibility(
            visible: errorDOB.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: errorDOB.value,
            ),
          ),
          const SizedBox(height: 20),
          genderPickerField(context),
          Visibility(
            visible: errorGender.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: errorGender.value,
            ),
          ),
          const SizedBox(height: Dimens.margin25),
          signUpButton(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [showConfirmPwd, showChoosePwd, isLoading, errorGender, errorDOB, errorConfirmPwd, errorChoosePwd, errorUserName],
            builder: (context, values, child) {
              return BlocListener<SignUpDetailsBloc, SignUpDetailsState>(
                listener: (context, state) {
                  isLoading.value = state is SignUpDetailsLoading;
                      if (state is SignUpDetailsFailure) {
                        if(state.errorMessage.generalError!.isNotEmpty)
                        {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                        if(state.errorMessage.generalError != null)
                        {
                         errorUserName.value = state.errorMessage.userExists ?? '';
                        }
                        if(state.errorMessage.invalidPassword != null)
                        {
                         errorConfirmPwd.value = state.errorMessage.invalidPassword ?? '';
                        }
                    }
                  if(state is SignUpDetailsResponse)
                    {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesScreenAboutUs,(route) => false, arguments: false);
                    }
                },
                child:  Scaffold(
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    body:NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo is ScrollUpdateNotification) {
                            FocusScope.of(context).unfocus();
                          }
                          return true;
                        },
                      child: BaseRoundedBackgroundWidget(
                        appBarText: getTranslate(APPStrings.textAccountSetUp),
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.only(top: 24),
                        child: Scaffold(
                          resizeToAvoidBottomInset: true,
                          backgroundColor: Colors.transparent,
                          body: SingleChildScrollView(child: getBody(context)),
                        ),
                      ),
                    ),
                ),
              );
            }));
  }

  validate() {
    bool isValid = true;
    if (userNameController.text.trim().isEmpty) {
      errorUserName.value = getTranslate(ValidationString.textValidateDisplayName);
      isValid = false;
    }
    if (choosePwdController.text.isEmpty) {
      errorChoosePwd.value = getTranslate(ValidationString.textValidateChoosePwd);
      isValid = false;
    }
    if (confirmPwdController.text.isEmpty) {
      errorConfirmPwd.value = getTranslate(ValidationString.textValidateCnfPwd);
      isValid = false;
    }
    if (choosePwdController.text.isNotEmpty && confirmPwdController.text.isNotEmpty && choosePwdController.text != confirmPwdController.text) {
      errorConfirmPwd.value = getTranslate(ValidationString.textValidatePwdNotMatches);
      isValid = false;
    }
    if (dateText == null) {
      errorDOB.value = getTranslate(ValidationString.textValidateSelectDob);
      isValid = false;
    }
    if (gender.type == null) {
      errorGender.value = getTranslate(ValidationString.textValidateSelectGender);
      isValid = false;
    }
    if (isValid) {
      uploadUserDetail();
    }
  }

  void uploadUserDetail()  {
    Map<String, dynamic> body = {
      AppConfig.paramUserName: userNameController.text.trim(),
      AppConfig.paramEmail: widget.modelSignUpDataTransfer.email.trim(),
      AppConfig.paramPassword: choosePwdController.text,
      AppConfig.paramCnfPassword: confirmPwdController.text,
      AppConfig.paramDOB: dateText,
      AppConfig.paramGender: gender.type,
      AppConfig.paramInvCode: widget.modelSignUpDataTransfer.code
    };

    BlocProvider.of<SignUpDetailsBloc>(context).add(UploadUserSignUpDetails(body: body, url: AppUrls.apiSignUpDetail));
  }
}
