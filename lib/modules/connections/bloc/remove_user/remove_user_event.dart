part of 'remove_user_bloc.dart';

abstract class RemoveUserFromInterestsEvent extends Equatable {
  const RemoveUserFromInterestsEvent();
  @override
  List<Object> get props => [];
}

class RemoveUserFromInterests extends RemoveUserFromInterestsEvent {
  final String url;

  const RemoveUserFromInterests({required this.url});
  @override
  List<Object> get props => [];
}
