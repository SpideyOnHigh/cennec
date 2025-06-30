part of 'accept_reject_requests_bloc.dart';

abstract class AcceptRejectRequestsEvent extends Equatable {
  const AcceptRejectRequestsEvent();
  @override
  List<Object> get props => [];
}

class AcceptRejectRequests extends AcceptRejectRequestsEvent {
  final Map<String,dynamic> body;
  final String url;

  const AcceptRejectRequests({required this.body, required this.url});
  @override
  List<Object> get props => [url,body];
}
