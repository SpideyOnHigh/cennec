part of 'post_profile_picture_bloc.dart';

abstract class PostProfilePictureState extends Equatable {
  const PostProfilePictureState();
}

class PostProfilePictureInitial extends PostProfilePictureState {
  @override
  List<Object> get props => [];
}

class PostProfilePictureLoading extends PostProfilePictureState {
  @override
  List<Object> get props => [];
}

class PostProfilePictureFailure extends PostProfilePictureState {
  final ModelError error;

  PostProfilePictureFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class PostProfilePictureResponse extends PostProfilePictureState {
  final ImageUploadResponse response;

  PostProfilePictureResponse({required this.response});
  @override
  List<Object> get props => [response];
}
