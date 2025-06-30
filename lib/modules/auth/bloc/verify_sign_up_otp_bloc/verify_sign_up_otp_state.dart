part of 'verify_sign_up_otp_bloc.dart';

abstract class VerifySignUpOtpState extends Equatable {
  const VerifySignUpOtpState();
  @override
  List<Object> get props => [];
}

class VerifySignUpOtpInitial extends VerifySignUpOtpState {
  @override
  List<Object> get props => [];
}

class VerifySignUpOtpLoading extends VerifySignUpOtpState {
  @override
  List<Object> get props => [];
}

class VerifySignUpOtpResponse extends VerifySignUpOtpState {
  final ModelOtpResetLink modelVerifySignUpOtp;

  const VerifySignUpOtpResponse({required this.modelVerifySignUpOtp});
  @override
  List<Object> get props => [];
}

class VerifySignUpOtpFailure extends VerifySignUpOtpState {
  final ModelError errorMessage;

  const VerifySignUpOtpFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
