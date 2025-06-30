part of 'sign_up_invitation_bloc.dart';

abstract class SignUpInvitationEvent extends Equatable {
  const SignUpInvitationEvent();
  @override
  List<Object> get props => [];
}

class VerifyInvitationCode extends SignUpInvitationEvent {
  final Map<String,dynamic> body;
  final String url;

  const VerifyInvitationCode({required this.body, required this.url});
  @override
  List<Object> get props => [];
}
