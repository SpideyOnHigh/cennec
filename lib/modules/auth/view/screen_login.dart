import 'package:cennec/modules/auth/bloc/login_bloc/login_bloc.dart';
import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/email_validation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/api_service/preference_helper.dart';
import '../../core/utils/common_import.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  ValueNotifier<bool> isShowPassword = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String> emailError = ValueNotifier('');
  ValueNotifier<String> pwdError = ValueNotifier('');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLarge = true;
  @override
  void initState() {
    if (kDebugMode) {
      emailController.text = "shivam.dubey@9spl.com";
      passwordController.text = "Test105*";
    }

    super.initState();
    // Trigger the animation after the widget is built
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isLarge = false;
      });
    });
  }

  Widget _buildLogo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _isLarge ? 200 : 100, // Start large, shrink to 100
      child: Image.asset(
        APPImages.icLogoWithName, // Update with your logo path
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textWelcomeBack).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin40,
        AppColors.colorDarkBlue,
        FontWeight.w700,
      ),
    );
  }

  Widget _buildEmailField() {
    return BaseTextFormFieldRounded(
      hintText: getTranslate(APPStrings.textEmail),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      controller: emailController,
      onChange: () {
        emailError.value = '';
      },
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget _buildPasswordField() {
    return BasePasswordTextFormField(
      hintText: getTranslate(APPStrings.textPassword),
      controller: passwordController,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
      onChange: () {
        pwdError.value = '';
      },
      isShowPassword: !isShowPassword.value,
      pressShowPassword: () {
        isShowPassword.value = !isShowPassword.value;
      },
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.routesForgotPwdEmail);
        },
        child: Text(
          getTranslate(APPStrings.textForgotPassword),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).colorScheme.secondary,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return CommonButton(
      isLoading: isLoading.value,
      text: getTranslate(APPStrings.textSignIn),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        validateFields();
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   AppRoutes.routesScreenDashboard,
        //   (route) => false,
        // );
        // Add Sign In functionality here
      },
    );
  }

  Widget _buildNoAccountText(BuildContext context) {
    return Center(
      child: Text(
        getTranslate(APPStrings.textNoAccount),
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.secondary,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.routesSignUp);
        },
        child: Text(
          getTranslate(APPStrings.textTapToSignUp),
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
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.margin50),
          _buildLogo(),
          const SizedBox(height: Dimens.margin60),
          _buildWelcomeText(context),
          const SizedBox(height: 40),
          _buildEmailField(),
          Visibility(
            visible: emailError.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: emailError.value,
            ),
          ),
          const SizedBox(height: 20),
          _buildPasswordField(),
          Visibility(
            visible: pwdError.value.isNotEmpty,
            child: BaseTextFieldErrorIndicator(
              errorText: pwdError.value,
            ),
          ),
          _buildForgotPasswordButton(context),
          const SizedBox(height: Dimens.margin20),
          _buildSignInButton(context),
          const SizedBox(height: 20),
          _buildNoAccountText(context),
          const SizedBox(height: 10),
          _buildSignUpButton(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiValueListenableBuilder(
          valueListenables: [isShowPassword, isLoading, emailError, pwdError],
          builder: (context, values, child) {
            return BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                isLoading.value = state is LoginLoading;
                if (state is LoginResponse) {
                  ToastController.showToast(context, state.modelLogin.message ?? '', true);
                  if (state.modelLogin.data?.hasInterests == true && state.modelLogin.data?.userData?.hasReadAboutUs == true) {
                    PreferenceHelper.setBool(PreferenceHelper.hasReadAboutUs, true);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.routesScreenDashboard,
                      (route) => false,
                    );
                  } else if (state.modelLogin.data?.userData?.hasReadAboutUs == false) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.routesScreenAboutUs,
                      arguments: false,
                      (route) => false,
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.routesScreenSignupInterests,
                      (route) => false,
                    );
                  }
                }
                if (state is LoginFailure) {
                  if (state.errorMessage.generalError!.isNotEmpty) {
                    ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                  } else {
                    ToastController.showToast(context, state.errorMessage.wrongCredentials ?? '', false);
                  }
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

  void validateFields() {
    bool isValid = true;
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      /// Display an error message for all three fields being empty
      emailError.value = getTranslate(ValidationString.textValidateReqEml);
      pwdError.value = getTranslate(ValidationString.textValidateReqPwd);
      isValid = false;
    } else if (emailController.text.isEmpty) {
      emailError.value = getTranslate(ValidationString.textValidateReqEml);
      isValid = false;
    } else if (emailController.text.isNotEmpty && !EmailValidation.validate(emailController.text.toString().trim())) {
      emailError.value = getTranslate(ValidationString.textInvalidEml);
      isValid = false;
    } else if (passwordController.text.isEmpty) {
      pwdError.value = getTranslate(ValidationString.textValidateReqPwd);
      isValid = false;
    }

    if (isValid) {
      loginEvent(emailController.text, passwordController.text);

      /// Reset any previous error messages
      // errorStringEmail.value = '';
      // errorStringPassword.value = '';
      // Navigator.pop(context);
      // Navigator.pushNamed(context, AppRoutes.routesPasscodeSignIn,
      //     arguments: false);
    }
  }

  loginEvent(String email, String password) async {
    Map<String, dynamic> body = {AppConfig.paramEmail: email, AppConfig.paramPassword: password,AppConfig.paramToken:PreferenceHelper.getString(PreferenceHelper.fcmToken)};
    BlocProvider.of<LoginBloc>(context).add(OnLogin(body: body, url: AppUrls.apiUserLogin));
  }
}
