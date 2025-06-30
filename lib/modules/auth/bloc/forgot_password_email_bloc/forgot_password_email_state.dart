part of 'forgot_password_email_bloc.dart';

abstract class ForgotPasswordEmailState extends Equatable {
  const ForgotPasswordEmailState();
  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailInitial extends ForgotPasswordEmailState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailLoading extends ForgotPasswordEmailState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailResponse extends ForgotPasswordEmailState {
  final ModelOtpResetLink modelOtpResetLink;

  const ForgotPasswordEmailResponse({required this.modelOtpResetLink});
  @override
  List<Object> get props => [modelOtpResetLink];
}

class ForgotPasswordEmailFailure extends ForgotPasswordEmailState {
  final ModelError errorMessage;

  const ForgotPasswordEmailFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
