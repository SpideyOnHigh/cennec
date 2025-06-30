part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class OnLogin extends LoginEvent {
  final Map<String,dynamic> body;
  final  String url;

  const OnLogin({required this.body, required this.url});

  @override
  List<Object> get props => [body,url];
}
