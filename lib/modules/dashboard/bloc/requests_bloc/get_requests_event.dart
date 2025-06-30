part of 'get_requests_bloc.dart';

abstract class GetRequestsEvent extends Equatable {
  const GetRequestsEvent();
  @override
  List<Object> get props => [];
}


class GetRequests extends GetRequestsEvent {
  final String url;

  const GetRequests({required this.url});
  @override
  List<Object> get props => [url];
}
