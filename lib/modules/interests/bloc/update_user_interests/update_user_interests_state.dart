part of 'update_user_interests_bloc.dart';


abstract class UpdateUserInterestsState extends Equatable {
  const UpdateUserInterestsState();
  @override
  List<Object> get props => [];
}

class UpdateUserInterestsInitial extends UpdateUserInterestsState {
  @override
  List<Object> get props => [];
}

class UpdateUserInterestsLoading extends UpdateUserInterestsState {
  @override
  List<Object> get props => [];
}

class UpdateUserInterestsResponse extends UpdateUserInterestsState {
  final ModelUpdateInterests modelUpdateInterests;

  const UpdateUserInterestsResponse({required this.modelUpdateInterests});
  @override
  List<Object> get props => [modelUpdateInterests];
}

class UpdateUserInterestsFailure extends UpdateUserInterestsState {
  final ModelError errorMessage;

  const UpdateUserInterestsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
