part of 'delete_connection_bloc.dart';

abstract class DeleteConnectionState extends Equatable {
  const DeleteConnectionState();
  @override
  List<Object> get props => [];
}

class DeleteConnectionInitial extends DeleteConnectionState {
  @override
  List<Object> get props => [];
}

class DeleteConnectionLoading extends DeleteConnectionState {
  @override
  List<Object> get props => [];
}

class DeleteConnectionResponse extends DeleteConnectionState {
  final ModelSuccess modelSuccess;

  const DeleteConnectionResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class DeleteConnectionFailure extends DeleteConnectionState {
  final ModelError errorMessage;

  const DeleteConnectionFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
