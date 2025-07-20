
part of 'add_user_post_bloc.dart';

abstract class AddUserPostState extends Equatable {
  const AddUserPostState();
  @override
  List<Object> get props => [];
}

class AddUserPostInitial extends AddUserPostState {
  @override
  List<Object> get props => [];
}

class AddUserPostLoading extends AddUserPostState {
  @override
  List<Object> get props => [];
}

class AddUserPostSuccess extends AddUserPostState {
  final String message;

  const AddUserPostSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddUserPostFailure extends AddUserPostState {
  final ModelError errorMessage;

  const AddUserPostFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}