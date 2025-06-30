part of 'get_my_connections_bloc.dart';

abstract class GetMyConnectionsState extends Equatable {
  const GetMyConnectionsState();
  @override
  List<Object> get props => [];
}

class GetMyConnectionsInitial extends GetMyConnectionsState {
  @override
  List<Object> get props => [];
}

class GetMyConnectionsLoading extends GetMyConnectionsState {
  @override
  List<Object> get props => [];
}

class GetMyConnectionsResponse extends GetMyConnectionsState {
  final ModelMyConnections modelMyConnections;

  const GetMyConnectionsResponse({required this.modelMyConnections});
  @override
  List<Object> get props => [modelMyConnections];
}

class GetMyConnectionsFailure extends GetMyConnectionsState {
  final ModelError errorMessage;

  const GetMyConnectionsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
