part of 'sign_up_invitation_bloc.dart';

abstract class SignUpInvitationState extends Equatable {
  const SignUpInvitationState();
  @override
  List<Object> get props => [];
}

class SignUpInvitationInitial extends SignUpInvitationState {
  @override
  List<Object> get props => [];
}

class SignUpInvitationLoading extends SignUpInvitationState {
  @override
  List<Object> get props => [];
}

class SignUpInvitationResponse extends SignUpInvitationState {
  final ModelSignUpInvCode modelSignUpInvCode;

  const SignUpInvitationResponse({required this.modelSignUpInvCode});
  @override
  List<Object> get props => [modelSignUpInvCode];
}

class SignUpInvitationFailure extends SignUpInvitationState {
  final ModelError errorMessage;

  const SignUpInvitationFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
