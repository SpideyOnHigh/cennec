part of 'get_user_profile_pic_bloc.dart';

abstract class GetUserProfilePicState extends Equatable {
  const GetUserProfilePicState();
  @override
  List<Object> get props => [];
}

class GetUserProfilePicInitial extends GetUserProfilePicState {
  @override
  List<Object> get props => [];
}

class GetUserProfilePicLoading extends GetUserProfilePicState {
  @override
  List<Object> get props => [];
}

class GetUserProfilePicResponse extends GetUserProfilePicState {
final ModelGetImages modelGetImages;

  const GetUserProfilePicResponse({required this.modelGetImages});
  @override
  List<Object> get props => [modelGetImages];
}

class GetUserProfilePicFailure extends GetUserProfilePicState {
  final ModelError errorMessage;

  const GetUserProfilePicFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
