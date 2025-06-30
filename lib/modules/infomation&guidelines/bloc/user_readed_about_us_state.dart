part of 'user_readed_about_us_bloc.dart';

abstract class UserReadedAboutUsState extends Equatable {
  const UserReadedAboutUsState();
  @override
  List<Object> get props => [];
}

class UserReadedAboutUsInitial extends UserReadedAboutUsState {
  @override
  List<Object> get props => [];
}

class UserReadedAboutUsLoading extends UserReadedAboutUsState {
  @override
  List<Object> get props => [];
}

class UserReadedAboutUsResponse extends UserReadedAboutUsState {
  final ModelSuccess modelSuccess;

  const UserReadedAboutUsResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class UserReadedAboutUsFailure extends UserReadedAboutUsState {
  final ModelError errorMessage;

  const UserReadedAboutUsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
