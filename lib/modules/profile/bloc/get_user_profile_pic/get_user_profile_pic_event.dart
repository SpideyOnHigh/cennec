part of 'get_user_profile_pic_bloc.dart';

abstract class GetUserProfilePicEvent extends Equatable {
  const GetUserProfilePicEvent();
  @override
  List<Object> get props => [];
}

class GetUserProfilePic extends GetUserProfilePicEvent {
  final String url;

  const GetUserProfilePic({required this.url});
  @override
  List<Object> get props => [url];
}
