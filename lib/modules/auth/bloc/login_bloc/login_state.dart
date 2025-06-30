part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginResponse extends LoginState {
  final ModelLogin modelLogin;

  const LoginResponse({required this.modelLogin});
  @override
  List<Object> get props => [modelLogin];
}

class LoginFailure extends LoginState {
  final ModelError errorMessage;

  const LoginFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
