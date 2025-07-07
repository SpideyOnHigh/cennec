import 'package:cennec/modules/auth/bloc/sign_up_inv_bloc/sign_up_invitation_bloc.dart';
import 'package:cennec/modules/auth/model/model_sign_up_data_transfer.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/email_validation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../core/api_service/preference_helper.dart';
import '../../core/common/widgets/base_rounded_corner_widget.dart';
import '../../core/common/widgets/base_text_field_error_indicator.dart';
import '../../core/common/widgets/common_text_field.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  bool agreedToTerms = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String> emailError = ValueNotifier('');
  ValueNotifier<String> codeError = ValueNotifier('');
  ValueNotifier<String> errorAgreement = ValueNotifier('');
  TextEditingController codeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Widget logo() {
    return Image.asset(
      APPImages.icLogoWithName, // Update with your logo path
      height: 100,
    );
  }

  // bool _isLarge = true;
  // @override
  // void initState() {
  //   super.initState();
  //   // Trigger the animation after the widget is built
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     setState(() {
  //       _isLarge = false;
  //     });
  //   });
  // }
  //
  // Widget logo() {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 500),
  //     height: _isLarge ? 200 : 100, // Start large, shrink to 100
  //     child: Image.asset(
  //       APPImages.icLogoWithName, // Update with your logo path
  //       fit: BoxFit.contain,
  //     ),
  //   );
  // }
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

  Widget letGetStartedText(BuildContext context) {
    return Text(getTranslate(APPStrings.textSignUpIntro).toString(),
        textAlign: TextAlign.center,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.secondary,
          FontWeight.w600,
        ));
  }

  Widget invitationCodeInfoText(BuildContext context) {
    return Text(getTranslate(APPStrings.textInvitationCodeInfo).toString(),
        textAlign: TextAlign.center,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.secondary,
          FontWeight.w600,
        ));
  }

  Widget emailField(BuildContext context) {
    return CommonTextFormField(
      label: getTranslate(APPStrings.textEmail),
      // hintText: getTranslate(APPStrings.textEmail),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      onChanged: (_) {
        if (emailError.value.isNotEmpty) {
          emailError.value = '';
        }
      },
    );
  }

  Widget invitationTextField(BuildContext context) {
    return CommonTextFormField(
      label: getTranslate(APPStrings.textInvitationCodePlaceholder),
      // hintText: getTranslate(APPStrings.textInvitationCodePlaceholder),
      controller: codeController,
      isOptional: true,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      onChanged: (_) {
        if (codeError.value.isNotEmpty) {
          codeError.value = '';
        }
      },
    );
  }

  Widget agreeTermsAndCondition(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0), // Adjust as needed
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              checkColor: Colors.white,
              activeColor: Theme.of(context).colorScheme.onSecondary,
              value: agreedToTerms,
              onChanged: (bool? value) {
                setState(() {
                  agreedToTerms = value ?? false;
                  if (errorAgreement.value.isNotEmpty) {
                    errorAgreement.value = '';
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin14,
                  Theme.of(context).colorScheme.onPrimary,
                  FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '${getTranslate(APPStrings.textIAgreeToThe)} ',
                  ),
                  TextSpan(
                    text: getTranslate(APPStrings.textTermsAndConditions),
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      Dimens.margin14,
                      AppColors.colorHyperLink, // Match image
                      FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.routesScreenCms,
                          arguments: AppConfig.paramTermCondition,
                        );
                      },
                  ),
                  TextSpan(
                    text: ' and ',
                  ),
                  TextSpan(
                    text: getTranslate(APPStrings.textPrivacyPolicy),
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      Dimens.margin14,
                      AppColors.colorHyperLink, // Match image
                      FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.routesScreenCms,
                          arguments: AppConfig.paramPrivacyPolicy,
                        );
                      },
                  ),
                  TextSpan(
                    text: ' ${getTranslate(APPStrings.textOfUse)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

/*  Widget signUpButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: Dimens.margin50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.routesVerifyEmail);
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
      text: getTranslate(APPStrings.textButtonContinue),
      isLoading: isLoading.value,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        validateFields();
        // Navigator.pushNamed(context, AppRoutes.routesVerifyEmail,arguments: ModelSignUpDataTransfer(
        //     email: emailController.text, invitationCode: codeController.text));
      },
    );
  }

  Widget alreadyAccountText(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            getTranslate(APPStrings.textHaveAccount), // "Already have an account?"
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin14,
              Theme.of(context).colorScheme.secondary,
              FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () {
              _onLoginTap(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              getTranslate(APPStrings.textSignIn), // "Log In"
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin14,
                Theme.of(context).colorScheme.onSecondary,
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLoginTap(BuildContext context) {
    Navigator.pop(context); // or Navigator.pushNamed(context, AppRoutes.login);
  }

  // Widget tapToSignIn(BuildContext context) {
  //   return Center(
  //     child: TextButton(
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //       child: Text(
  //         getTranslate(APPStrings.textTapToSignIn),
  //         style: getTextStyleFromFont(
  //           AppFont.poppins,
  //           Dimens.margin22,
  //           Theme.of(context).colorScheme.onSecondary,
  //           FontWeight.w700,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(height: Dimens.margin10),
          // logo(),
          // const SizedBox(height: Dimens.margin30),
          // signUpText(context),
          // const SizedBox(height: 20),
          // letGetStartedText(context),
          // const SizedBox(height: 20),
          emailField(context),
          Visibility(
            visible: emailError.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: emailError.value,
            ),
          ),
          const SizedBox(height: 20),
          invitationTextField(context),
          Visibility(
            visible: codeError.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: codeError.value,
            ),
          ),

          const SizedBox(height: 20),
          agreeTermsAndCondition(context),
          Visibility(
            visible: errorAgreement.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: errorAgreement.value,
            ),
          ),
          const SizedBox(height: Dimens.margin25),
          signUpButton(context),

          const SizedBox(height: 20),
          alreadyAccountText(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isLoading, codeError, emailError,errorAgreement],
        builder: (context, values, child) {
          return BlocListener<SignUpInvitationBloc, SignUpInvitationState>(
            listener: (context, state) {
              isLoading.value = state is SignUpInvitationLoading;
              if (state is SignUpInvitationFailure) {
                if(state.errorMessage.generalError!.isNotEmpty)
                  {
                    ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                  }
                else {
                  if (state.errorMessage.invitationCode != null) {
                    codeError.value = state.errorMessage.invitationCode ?? '';
                  }
                  if(state.errorMessage.userExists != null)
                    {
                      emailError.value = state.errorMessage.userExists ?? '';
                    }
                }
              }
              if (state is SignUpInvitationResponse) {
                ToastController.showToast(context, state.modelSignUpInvCode.message ?? '', true);
                Navigator.pushReplacementNamed(context, AppRoutes.routesVerifyEmail,
                    arguments: ModelSignUpDataTransfer(email: emailController.text, code: codeController.text));
              }
            },
            child: BaseRoundedBackgroundWidget(
              appBarText: getTranslate(APPStrings.textSignUp),
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.only(top: 24),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(child: getBody(context)),
              ),
            ),
          );
        });
  }

  void validateFields() {
    bool isValid = true;
    if (emailController.text.isEmpty && codeController.text.isEmpty) {
      /// Display an error message for all three fields being empty
      emailError.value = getTranslate(ValidationString.textValidateReqEml);
      codeError.value = getTranslate(ValidationString.textValidateInvCode);
      // codeError.value = "Invitation code is required";
      isValid = false;
    }
    if (emailController.text.isEmpty) {
      emailError.value = getTranslate(ValidationString.textValidateReqEml);
      isValid = false;
    }
    if (emailController.text.isNotEmpty && !EmailValidation.validate(emailController.text.toString().trim())) {
      emailError.value = getTranslate(ValidationString.textInvalidEml);
      isValid = false;
    }
    if (codeController.text.isEmpty) {
      codeError.value = getTranslate(ValidationString.textValidateInvCode);
      isValid = false;
    }
    if (agreedToTerms == false) {
      isValid = false;
      errorAgreement.value = getTranslate(ValidationString.textValidateTermsAndCondition);
      // ToastController.showToast(context, getTranslate(ValidationString.textValidateTermsAndCondition), false);
    }

    if (isValid) {

      getSignUpCode();
    }
  }

  void getSignUpCode()  {
    Map<String, dynamic> body = {AppConfig.paramEmail: emailController.text, AppConfig.paramInvCode: codeController.text,AppConfig.paramToken:PreferenceHelper.getString(PreferenceHelper.fcmToken)};
    BlocProvider.of<SignUpInvitationBloc>(context).add(VerifyInvitationCode(body: body, url: AppUrls.apiUserSignUpInvCode));
  }
}
