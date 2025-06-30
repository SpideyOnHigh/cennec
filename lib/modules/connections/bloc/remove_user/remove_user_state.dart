part of 'remove_user_bloc.dart';

abstract class RemoveUserFromInterestsState extends Equatable {
  const RemoveUserFromInterestsState();
}

class RemoveUserFromInterestsInitial extends RemoveUserFromInterestsState {
  @override
  List<Object> get props => [];
}

class RemoveUserFromInterestsLoading extends RemoveUserFromInterestsState {
  @override
  List<Object> get props => [];
}

class RemoveUserFromInterestsResponse extends RemoveUserFromInterestsState {
  final ModelSuccess modelSuccess;

  const RemoveUserFromInterestsResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class RemoveUserFromInterestsFailure extends RemoveUserFromInterestsState {
  final ModelError errorMessage;

  const RemoveUserFromInterestsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
