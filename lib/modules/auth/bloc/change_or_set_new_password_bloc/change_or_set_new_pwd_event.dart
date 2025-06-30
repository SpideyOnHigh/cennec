part of 'change_or_set_new_pwd_bloc.dart';

abstract class ChangeOrSetNewPwdEvent extends Equatable {
  const ChangeOrSetNewPwdEvent();
  @override
  List<Object> get props => [];
}


class ChangeOrSetNewPwd extends ChangeOrSetNewPwdEvent {
final Map<String,dynamic> body;
final String url;

  const ChangeOrSetNewPwd({required this.body, required this.url});

  @override
  List<Object> get props => [body,url];
}


class ResetPwd extends ChangeOrSetNewPwdEvent {
final Map<String,dynamic> body;
final String url;

  const ResetPwd({required this.body, required this.url});

  @override
  List<Object> get props => [body,url];
}
