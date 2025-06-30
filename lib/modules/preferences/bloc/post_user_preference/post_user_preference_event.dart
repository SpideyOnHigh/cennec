part of 'post_user_preference_bloc.dart';

abstract class PostUserPreferenceEvent extends Equatable {
  const PostUserPreferenceEvent();
  @override
  List<Object> get props => [];
}

class PostUserPreference extends PostUserPreferenceEvent {
  final Map<String,dynamic> body;
  final String url;

  const PostUserPreference({required this.body, required this.url});
  @override
  List<Object> get props => [];
}
