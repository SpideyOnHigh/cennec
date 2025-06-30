part of 'post_profile_picture_bloc.dart';

abstract class PostProfilePictureEvent extends Equatable {
  const PostProfilePictureEvent();
}

class PostProfilePictureApi extends PostProfilePictureEvent {
  final String url;
  final Map<String,String> body;
  final List<ProfilePictureModel> imageList;

  const PostProfilePictureApi({required this.url,required this.body,required this.imageList});
  @override
  List<Object> get props => [];
}
