part of 'update_user_profile_bloc.dart';

abstract class UpdateUserProfileEvent extends Equatable {
  const UpdateUserProfileEvent();
  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends UpdateUserProfileEvent {
  final Map<String, dynamic> body;
  final String url;

  const UpdateUserProfile({required this.body, required this.url});
  @override
  List<Object> get props => [body, url];
}
