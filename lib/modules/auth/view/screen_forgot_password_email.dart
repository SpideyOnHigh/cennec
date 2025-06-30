import 'package:cennec/modules/auth/bloc/forgot_password_email_bloc/forgot_password_email_bloc.dart';
import 'package:cennec/modules/auth/model/model_sign_up_data_transfer.dart';
import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/email_validation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

class ScreenForgotPasswordEmail extends StatefulWidget {
  const ScreenForgotPasswordEmail({super.key});

  @override
  State<ScreenForgotPasswordEmail> createState() => _ScreenForgotPasswordEmailState();
}

class _ScreenForgotPasswordEmailState extends State<ScreenForgotPasswordEmail> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String> errorEmail = ValueNotifier('');
  TextEditingController emailController = TextEditingController();

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

  Widget forgotPasswordText(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getTranslate(APPStrings.textForgotPwdWoQ),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin40,
          AppColors.colorDarkBlue,
          FontWeight.w700,
        ),
      ),
    );
  }

  Widget enterEmailText(BuildContext context) {
    return Text(getTranslate(APPStrings.textEnterEmailInstructions),
        // textAlign: TextAlign.center,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.onPrimary,
          FontWeight.w600,
        ));
  }

  Widget emailField(BuildContext context) {
    return BaseTextFormFieldRounded(
      hintText: getTranslate(APPStrings.textEmail),
      controller: emailController,
      onChange: () {
        if (errorEmail.value.isNotEmpty) {
          errorEmail.value = '';
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

/*  Widget nextButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: Dimens.margin50,
      child: ElevatedButton(
        onPressed: () {
           Navigator.pushNamed(context, AppRoutes.routesScreenForgotPasswordOtp);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorDarkBlue,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          getTranslate(APPStrings.textButtonContinue),
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

  Widget nextButton(BuildContext context) {
    return CommonButton(
      text: getTranslate(APPStrings.textButtonContinue),
      backgroundColor: Theme.of(context).colorScheme.primary,
      isLoading: isLoading.value,
      onTap: () {
        validateFields();
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
              forgotPasswordText(context),
              const SizedBox(height: 30),
              enterEmailText(context),
              const SizedBox(height: 30),
              emailField(context),
              Visibility(
                  visible: errorEmail.value.isNotEmpty,
                  child: BaseTextFieldErrorIndicator(
                    errorText: errorEmail.value,
                  )),
              const SizedBox(height: 70),
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
            valueListenables: [isLoading, errorEmail],
            builder: (context, values, child) {
              return BlocListener<ForgotPasswordEmailBloc, ForgotPasswordEmailState>(
                listener: (context, state) {
                  isLoading.value = state is ForgotPasswordEmailLoading;
                  if (state is ForgotPasswordEmailFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                    if (state.errorMessage.email != null) {
                      errorEmail.value = state.errorMessage.email ?? '';
                    }
                  }
                  if (state is ForgotPasswordEmailResponse) {
                    ToastController.showToast(context, state.modelOtpResetLink.message ?? '', true);
                    Navigator.popAndPushNamed(context, AppRoutes.routesScreenForgotPasswordOtp,
                        arguments: ModelSignUpDataTransfer(email: emailController.text, code: ''));
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

  void validateFields() {
    bool isValid = true;
    if (emailController.text.isEmpty) {
      errorEmail.value = getTranslate(ValidationString.textValidateReqEml);
      isValid = false;
    }
    if (emailController.text.isNotEmpty && !EmailValidation.validate(emailController.text.toString().trim())) {
      errorEmail.value = getTranslate(ValidationString.textInvalidEml);
      isValid = false;
    }

    if (isValid) {
      sendEmailVerification();
    }
  }

  void sendEmailVerification()  {
    Map<String, dynamic> body = {AppConfig.paramEmail: emailController.text.trim()};
    BlocProvider.of<ForgotPasswordEmailBloc>(context).add(VerifyEmailForForgotPassword(body: body, url: AppUrls.apiSendResetLink));
  }
}
