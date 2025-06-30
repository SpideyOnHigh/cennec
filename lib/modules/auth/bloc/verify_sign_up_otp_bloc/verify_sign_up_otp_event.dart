part of 'verify_sign_up_otp_bloc.dart';

abstract class VerifySignUpOtpEvent extends Equatable {
  const VerifySignUpOtpEvent();
  @override
  List<Object> get props => [];
}

class VerifySignUpOtp extends VerifySignUpOtpEvent {
  final Map<String, dynamic> body;
  final String url;

  const VerifySignUpOtp({required this.body, required this.url});
  @override
  List<Object> get props => [body,url];
}
