part of 'get_user_preference_bloc.dart';

abstract class GetUserPreferenceState extends Equatable {
  const GetUserPreferenceState();
  @override
  List<Object> get props => [];
}

class GetUserPreferenceInitial extends GetUserPreferenceState {
  @override
  List<Object> get props => [];
}

class GetUserPreferenceLoading extends GetUserPreferenceState {
  @override
  List<Object> get props => [];
}

class GetUserPreferenceResponse extends GetUserPreferenceState {
  final ModelPreferences modelPreferences;

  const GetUserPreferenceResponse({required this.modelPreferences});
  @override
  List<Object> get props => [modelPreferences];
}

class GetUserPreferenceFailure extends GetUserPreferenceState {
  final ModelError errorMessage;

  const GetUserPreferenceFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
