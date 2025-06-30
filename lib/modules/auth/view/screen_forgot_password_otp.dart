import 'package:cennec/modules/auth/bloc/forgot_password_email_bloc/forgot_password_email_bloc.dart';
import 'package:cennec/modules/auth/bloc/verify_sign_up_otp_bloc/verify_sign_up_otp_bloc.dart';
import 'package:cennec/modules/auth/model/model_sign_up_data_transfer.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../core/utils/common_import.dart';

class ScreenForgotPasswordOtp extends StatefulWidget {
  final ModelSignUpDataTransfer modelSignUpDataTransfer;
  const ScreenForgotPasswordOtp({super.key, required this.modelSignUpDataTransfer});

  @override
  State<ScreenForgotPasswordOtp> createState() => _ScreenForgotPasswordOtpState();
}

class _ScreenForgotPasswordOtpState extends State<ScreenForgotPasswordOtp> {
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  final TextEditingController _otpController = TextEditingController();
  String smsOTP = '';

  final ValueNotifier<int> _timerNotifier = ValueNotifier<int>(30);
  final ValueNotifier<int> _attemptNotifier = ValueNotifier<int>(3);
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timerNotifier.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerNotifier.value > 0) {
        _timerNotifier.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void _resendOtp() {
    if (_attemptNotifier.value >= 1) {
      _attemptNotifier.value--;
      sendEmailVerification();
      _startTimer(); // Restart the timer
      // Trigger OTP resend logic here
    } else {
      printWrapped("bhadddd me jaoooooooo : ${_attemptNotifier.value}");
      // Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerNotifier.dispose();
    _attemptNotifier.dispose();
    super.dispose();
  }

  void sendEmailVerification()  {
    Map<String, dynamic> body = {AppConfig.paramEmail: widget.modelSignUpDataTransfer.email};
    BlocProvider.of<ForgotPasswordEmailBloc>(context).add(VerifyEmailForForgotPassword(body: body, url: AppUrls.apiSendResetLink));
  }

  Widget resendButton() {
    return Visibility(
      visible: _timerNotifier.value == 0,
      replacement: ValueListenableBuilder<int>(
        valueListenable: _timerNotifier,
        builder: (context, value, child) {
          return Text(
            'Resend OTP in $value seconds',
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin18,
              Theme.of(context).colorScheme.onPrimary,
              FontWeight.w600,
            ),
          );
        },
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _attemptNotifier,
        builder: (context, value, child) {
          return SizedBox(
            width: Dimens.margin150,
            child: CommonButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(Dimens.margin10)),
              height: Dimens.margin40,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.margin5),
              onTap: value > 0 && _timerNotifier.value == 0 ? _resendOtp : null,
              text: 'Resend OTP',
            ),
          );
        },
      ),
    );
  }

  Widget navigationWithLogo() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.popAndPushNamed(context, AppRoutes.routesForgotPwdEmail);
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

  Widget sensitiveCodeText(BuildContext context) {
    return Text(
        "${getTranslate(APPStrings.textTimeSensitiveCodeSent)} ${widget.modelSignUpDataTransfer.email}. ${getTranslate(APPStrings.textPleaseCheckInboxForChangePwd)}",
        textAlign: TextAlign.center,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.onPrimary,
          FontWeight.w600,
        ));
  }

  /// [pinCodeBox] This function is use for show pin code box
  Widget pinCodeBox() {
    return Form(
      key: formKey,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.margin10),
          child: PinCodeTextField(
            appContext: context,
            textStyle: TextStyle(color: Theme.of(context).hintColor, fontFamily: AppFont.poppins, fontSize: Dimens.margin30),
            showCursor: false,
            length: 4,
            blinkWhenObscuring: true,
            hintCharacter: '',
            hintStyle: getTextStyleFromFont(AppFont.poppins, Dimens.margin24, Theme.of(context).hintColor, FontWeight.w700),
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(Dimens.margin15),
                fieldHeight: Dimens.margin60,
                fieldWidth: Dimens.margin60,
                activeFillColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                selectedFillColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).colorScheme.secondary,
                inactiveFillColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColor),
            autoFocus: true,
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: _otpController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            boxShadows: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0.5,
              )
            ],
            onCompleted: (v) {},
            onChanged: (value) {
              setState(() {
                smsOTP = value;
              });
            },
            beforeTextPaste: (text) {
              return true;
            },
          )),
    );
  }

/*  Widget nextButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: Dimens.margin50,
      child: ElevatedButton(
        onPressed: () {
           Navigator.pushNamed(context, AppRoutes.routesScreenChangePasswordInAuth);
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
  }  */

  Widget nextButton(BuildContext context) {
    return CommonButton(
      text: getTranslate(APPStrings.textButtonContinue),
      backgroundColor: Theme.of(context).colorScheme.primary,
      isLoading: isLoading.value,
      onTap: () {
        validate();

        // Navigator.pushNamed(context, AppRoutes.routesScreenSetNewPassword);
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
              sensitiveCodeText(context),
              const SizedBox(height: 30),
              pinCodeBox(),
              const SizedBox(height: 30),
              resendButton(),
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
    return MultiValueListenableBuilder(
        valueListenables: [isLoading, _timerNotifier, _attemptNotifier],
        builder: (context, values, child) {
          return SafeArea(
              child: MultiBlocListener(
            listeners: [
              BlocListener<VerifySignUpOtpBloc, VerifySignUpOtpState>(
                listener: (context, state) {
                  isLoading.value = state is VerifySignUpOtpLoading;
                  if (state is VerifySignUpOtpFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                    if (state.errorMessage.wrongOtp != null) {
                      ToastController.showToast(context, state.errorMessage.wrongOtp ?? '', false);
                    }
                  }
                  if (state is VerifySignUpOtpResponse) {
                    ToastController.showToast(context, state.modelVerifySignUpOtp.message ?? '', true);
                    Navigator.pushNamed(context, AppRoutes.routesScreenSetNewPassword,
                        arguments: ModelSignUpDataTransfer(email: widget.modelSignUpDataTransfer.email, code: smsOTP));
                  }
                },
              ),
              BlocListener<ForgotPasswordEmailBloc, ForgotPasswordEmailState>(
                listener: (context, state) {
                  isLoading.value = state is ForgotPasswordEmailLoading;
                  if (state is ForgotPasswordEmailResponse) {
                    ToastController.showToast(context, state.modelOtpResetLink.message ?? '', true);
                  }
                },
              )
            ],
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SingleChildScrollView(child: getBody(context)),
            ),
          ));
        });
  }

  validate() {
    if (smsOTP.length < 4) {
      ToastController.showToast(context, "Please fill Otp", false);
    } else {
      verifyOtp();
    }
  }

  void verifyOtp() async {
    Map<String, dynamic> body = {AppConfig.paramEmail: widget.modelSignUpDataTransfer.email, AppConfig.paramOtp: smsOTP};
    BlocProvider.of<VerifySignUpOtpBloc>(context).add(VerifySignUpOtp(body: body, url: AppUrls.apiValidateOtp));
  }
}
