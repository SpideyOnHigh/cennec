part of 'get_user_profile_pref_bloc.dart';

abstract class GetUserProfilePrefEvent extends Equatable {
  const GetUserProfilePrefEvent();
  @override
  List<Object> get props => [];
}

class GetUserProfilePref extends GetUserProfilePrefEvent {
  final String url;

  const GetUserProfilePref({required this.url});
  @override
  List<Object> get props => [];
}
