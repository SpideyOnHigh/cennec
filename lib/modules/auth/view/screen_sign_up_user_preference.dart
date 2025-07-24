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
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController choosePwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  ValueNotifier<bool> showChoosePwd = ValueNotifier(false);
  ValueNotifier<bool> showConfirmPwd = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  // errorShowers
  ValueNotifier<String> errorUserName = ValueNotifier('');
  ValueNotifier<String> errorChoosePwd = ValueNotifier('');
  ValueNotifier<String> errorMobilePwd = ValueNotifier('');
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

  Widget mobileNumberField(BuildContext context) {
    return CommonTextFormField(
      controller: mobileNumberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10), // Adjust based on your country
        FilteringTextInputFormatter.deny(RegExp(r'^\s')), // No leading spaces
      ],
      onChanged: (value) {
        if (errorMobilePwd.value.isNotEmpty) {
          errorMobilePwd.value = '';
        }
        // Optional: Real-time validation
        // if (value.length == 10) {
        //   // Trigger validation or formatting
        // }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return getTranslate(APPStrings.textConfirmPassword);
        }
        if (value.length < 10) {
          return getTranslate(APPStrings.textMobileInvalid);
        }
        // Add more validation as needed (e.g., specific country format)
        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) { // Indian mobile format
          return getTranslate(APPStrings.textMobileInvalid);
        }
        return null;
      },
      label: getTranslate(APPStrings.textMobileNumber), // Updated label
      // prefixIcon: Icon(Icons.phone), // Optional: Phone icon
      // hintText: getTranslate(APPStrings.textMobileHint), // e.g., "Enter 10-digit mobile number"
    );
  }

  Widget choosePasswordField(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showChoosePwd,
      builder: (context, isShowPassword, child) {
        return CommonPasswordTextFormField(
          label: getTranslate(APPStrings.textChoosePassword),
          controller: choosePwdController,
          isShowPassword: isShowPassword,
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
      },
    );
  }

  Widget confirmPasswordField(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showConfirmPwd,
      builder: (context, isShowPassword, child) {
        return CommonPasswordTextFormField(
          label: getTranslate(APPStrings.textConfirmPassword),
          controller: confirmPwdController,
          isShowPassword: isShowPassword,
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

  Widget signUpButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        return CommonButton(
          isLoading: loading,
          text: getTranslate(APPStrings.textNext),
          backgroundColor: Theme.of(context).colorScheme.primary,
          onTap: () {
            validate();
            // Navigator.pushNamed(context, AppRoutes.routesScreenAboutUs, arguments: false);
          },
        );
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
          ValueListenableBuilder<String>(
            valueListenable: errorUserName,
            builder: (context, error, child) {
              return Visibility(
                visible: error.isNotEmpty,
                child: BaseTextFieldErrorIndicator(
                  errorText: error,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          mobileNumberField(context),
          ValueListenableBuilder<String>(
            valueListenable: errorMobilePwd,
            builder: (context, error, child) {
              return Visibility(
                visible: error.isNotEmpty,
                child: BaseTextFieldErrorIndicator(
                  errorText: error,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          choosePasswordField(context),
          ValueListenableBuilder<String>(
            valueListenable: errorChoosePwd,
            builder: (context, error, child) {
              return Visibility(
                visible: error.isNotEmpty,
                child: BaseTextFieldErrorIndicator(
                  errorText: error,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          confirmPasswordField(context),
          ValueListenableBuilder<String>(
            valueListenable: errorConfirmPwd,
            builder: (context, error, child) {
              return Visibility(
                visible: error.isNotEmpty,
                child: BaseTextFieldErrorIndicator(
                  errorText: error,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          datePickerField(context),
          ValueListenableBuilder<String>(
            valueListenable: errorDOB,
            builder: (context, error, child) {
              return Visibility(
                visible: error.isNotEmpty,
                child: BaseTextFieldErrorIndicator(
                  errorText: error,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          genderPickerField(context),
          ValueListenableBuilder<String>(
            valueListenable: errorGender,
            builder: (context, error, child) {
              return Visibility(
                visible: error.isNotEmpty,
                child: BaseTextFieldErrorIndicator(
                  errorText: error,
                ),
              );
            },
          ),
          const SizedBox(height: Dimens.margin25),
          signUpButton(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpDetailsBloc, SignUpDetailsState>(
      listener: (context, state) {
        isLoading.value = state is SignUpDetailsLoading;
        if (state is SignUpDetailsFailure) {
          if(state.errorMessage.generalError!.isNotEmpty) {
            ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
          }
          if(state.errorMessage.generalError != null) {
            errorUserName.value = state.errorMessage.userExists ?? '';
          }
          if(state.errorMessage.invalidPassword != null) {
            errorConfirmPwd.value = state.errorMessage.invalidPassword ?? '';
          }
        }
        if(state is SignUpDetailsResponse) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesScreenAboutUs,(route) => false, arguments: false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BaseRoundedBackgroundWidget(
          appBarText: getTranslate(APPStrings.textAccountSetUp),
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(top: 24),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: getBody(context),
            ),
          ),
        ),
      ),
    );
  }

  validate() {
    bool isValid = true;
    if (userNameController.text.trim().isEmpty) {
      errorUserName.value = getTranslate(ValidationString.textValidateDisplayName);
      isValid = false;
    }
    if (mobileNumberController.text.trim().isEmpty) {
      errorMobilePwd.value = getTranslate(ValidationString.textValidateMobileNumber);
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
      AppConfig.paramMobile: mobileNumberController.text.trim(),
      AppConfig.paramInvCode: widget.modelSignUpDataTransfer.code
    };

    BlocProvider.of<SignUpDetailsBloc>(context).add(UploadUserSignUpDetails(body: body, url: AppUrls.apiSignUpDetail));
  }

  @override
  void dispose() {
    // Dispose controllers and ValueNotifiers to prevent memory leaks
    userNameController.dispose();
    mobileNumberController.dispose();
    choosePwdController.dispose();
    confirmPwdController.dispose();
    showChoosePwd.dispose();
    showConfirmPwd.dispose();
    isLoading.dispose();
    errorUserName.dispose();
    errorChoosePwd.dispose();
    errorMobilePwd.dispose();
    errorConfirmPwd.dispose();
    errorDOB.dispose();
    errorGender.dispose();
    super.dispose();
  }
}