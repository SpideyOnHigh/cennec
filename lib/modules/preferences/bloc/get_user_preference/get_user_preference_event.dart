part of 'get_user_preference_bloc.dart';

abstract class GetUserPreferenceEvent extends Equatable {
  const GetUserPreferenceEvent();
  @override
  List<Object> get props => [];
}

class GetUserPreference extends GetUserPreferenceEvent {
  final String url;
  const GetUserPreference({required this.url});
  @override
  List<Object> get props => [];
}
