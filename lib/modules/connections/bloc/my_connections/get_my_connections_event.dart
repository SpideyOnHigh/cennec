part of 'get_my_connections_bloc.dart';

abstract class GetMyConnectionsEvent extends Equatable {
  const GetMyConnectionsEvent();
  @override
  List<Object> get props => [];
}

class GetMyConnections extends GetMyConnectionsEvent {
  final String url;

  const GetMyConnections({required this.url});
  @override
  List<Object> get props => [url];
}
