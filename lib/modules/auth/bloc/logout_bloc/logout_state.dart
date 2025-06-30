part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();
  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {
  @override
  List<Object> get props => [];
}

class LogoutLoading extends LogoutState {
  @override
  List<Object> get props => [];
}

class LogoutResponse extends LogoutState {
  final ModelLogoutSuccess modelLogoutSuccess;
  const LogoutResponse({required this.modelLogoutSuccess});

  @override
  List<Object> get props => [modelLogoutSuccess];
}

class LogoutFailure extends LogoutState {
  final ModelError errorMessage;

  const LogoutFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
