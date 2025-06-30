part of 'delete_profile_bloc.dart';

abstract class DeleteProfileState extends Equatable {
  const DeleteProfileState();
  @override
  List<Object> get props => [];
}

class DeleteProfileInitial extends DeleteProfileState {
  @override
  List<Object> get props => [];
}

class DeleteProfileLoading extends DeleteProfileState {
  @override
  List<Object> get props => [];
}

class DeleteProfileResponse extends DeleteProfileState {
  final ModelSuccess modelSuccess;

  const DeleteProfileResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class DeleteProfileFailure extends DeleteProfileState {
  final ModelError errorMessage;

  const DeleteProfileFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
