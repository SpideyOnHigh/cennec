part of 'logout_bloc.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();
  @override
  List<Object> get props => [];
}

class UserLogout extends LogoutEvent {

  final String url;

  const UserLogout({required this.url});
  @override
  List<Object> get props => [url];
}
