part of 'set_default_profile_pic_bloc.dart';

abstract class SetDefaultProfilePicState extends Equatable {
  const SetDefaultProfilePicState();
}

class SetDefaultProfilePicInitial extends SetDefaultProfilePicState {
  @override
  List<Object> get props => [];
}

class SetDefaultProfilePicLoading extends SetDefaultProfilePicState {
  @override
  List<Object> get props => [];
}

class SetDefaultProfilePicResponse extends SetDefaultProfilePicState {
  final ModelSuccess modelSuccess;

  const SetDefaultProfilePicResponse({required this.modelSuccess});
  @override
  List<Object> get props => [];
}

class SetDefaultProfilePicFailure extends SetDefaultProfilePicState {
  final ModelError errorMessage;

  const SetDefaultProfilePicFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
