part of 'update_user_profile_bloc.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();
}

class UpdateUserProfileInitial extends UpdateUserProfileState {
  @override
  List<Object> get props => [];
}

class UpdateUserProfileLoading extends UpdateUserProfileState {
  @override
  List<Object> get props => [];
}

class UpdateUserProfileResponse extends UpdateUserProfileState {
  final ModelUpdatedProfileData modelUpdatedProfileData;

  const UpdateUserProfileResponse({required this.modelUpdatedProfileData});
  @override
  List<Object> get props => [modelUpdatedProfileData];
}

class UpdateUserProfileFailure extends UpdateUserProfileState {
  final ModelError errorMessage;

  const UpdateUserProfileFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
