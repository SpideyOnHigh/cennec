part of 'get_user_profile_pref_bloc.dart';

abstract class GetUserProfilePrefState extends Equatable {
  const GetUserProfilePrefState();
}

class GetUserProfilePrefInitial extends GetUserProfilePrefState {
  @override
  List<Object> get props => [];
}

class GetUserProfilePrefLoading extends GetUserProfilePrefState {
  @override
  List<Object> get props => [];
}

class GetUserProfilePrefResponse extends GetUserProfilePrefState {
  final ModelUserEditProfilePrefs modelUserEditProfilePrefs;

  const GetUserProfilePrefResponse({required this.modelUserEditProfilePrefs});
  @override
  List<Object> get props => [modelUserEditProfilePrefs];
}

class GetUserProfilePrefFailure extends GetUserProfilePrefState {
  final ModelError errorMessage;

  const GetUserProfilePrefFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
