part of 'delete_connection_bloc.dart';

abstract class DeleteConnectionEvent extends Equatable {
  const DeleteConnectionEvent();
  @override
  List<Object> get props => [];
}

class DeleteConnection extends DeleteConnectionEvent {
  final String url;
  const DeleteConnection({required this.url});
  @override
  List<Object> get props => [url];
}
