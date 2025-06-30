part of 'forgot_password_email_bloc.dart';

abstract class ForgotPasswordEmailEvent extends Equatable {
  const ForgotPasswordEmailEvent();
  @override
  List<Object> get props => [];
}

class VerifyEmailForForgotPassword extends ForgotPasswordEmailEvent {
  final Map<String,dynamic> body;
  final String url;

  const VerifyEmailForForgotPassword({required this.body, required this.url});
  @override
  List<Object> get props => [body,url];
}
