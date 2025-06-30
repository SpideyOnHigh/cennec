part of 'user_readed_about_us_bloc.dart';

abstract class UserReadedAboutUsEvent extends Equatable {
  const UserReadedAboutUsEvent();
  @override
  List<Object> get props => [];

}

class UserReadedAboutUs extends UserReadedAboutUsEvent {
  final String url;

  const UserReadedAboutUs({required this.url});

}
