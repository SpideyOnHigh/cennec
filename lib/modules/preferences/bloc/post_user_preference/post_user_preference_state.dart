part of 'post_user_preference_bloc.dart';

abstract class PostUserPreferenceState extends Equatable {
  const PostUserPreferenceState();
  @override
  List<Object> get props => [];
}

class PostUserPreferenceInitial extends PostUserPreferenceState {
  @override
  List<Object> get props => [];
}

class PostUserPreferenceLoading extends PostUserPreferenceState {
  @override
  List<Object> get props => [];
}

class PostUserPreferenceResponse extends PostUserPreferenceState {
  final ModelPreferences modelPreferences;

  const PostUserPreferenceResponse({required this.modelPreferences});
  @override
  List<Object> get props => [modelPreferences];
}

class PostUserPreferenceFailure extends PostUserPreferenceState {
  final ModelError errorMessage;

  const PostUserPreferenceFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
