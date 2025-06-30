part of 'remove_user_from_details_bloc.dart';

abstract class RemoveUserFromDetailsState extends Equatable {
  const RemoveUserFromDetailsState();
}

class RemoveUserFromDetailsInitial extends RemoveUserFromDetailsState {
  @override
  List<Object> get props => [];
}

class RemoveUserFromDetailsLoading extends RemoveUserFromDetailsState {
  @override
  List<Object> get props => [];
}

class RemoveUserFromDetailsResponse extends RemoveUserFromDetailsState {
  final ModelSuccess modelSuccess;

  const RemoveUserFromDetailsResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class RemoveUserFromDetailsFailure extends RemoveUserFromDetailsState {
  final ModelError errorMessage;

  const RemoveUserFromDetailsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
