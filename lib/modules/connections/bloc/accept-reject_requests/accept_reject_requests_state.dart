part of 'accept_reject_requests_bloc.dart';

abstract class AcceptRejectRequestsState extends Equatable {
  const AcceptRejectRequestsState();
  @override
  List<Object> get props => [];
}

class AcceptRejectRequestsInitial extends AcceptRejectRequestsState {
  @override
  List<Object> get props => [];
}

class AcceptRejectRequestsLoading extends AcceptRejectRequestsState {
  @override
  List<Object> get props => [];
}

class AcceptRejectRequestsResponse extends AcceptRejectRequestsState {
  final ModelRequestAction modelRequestAction;

  const AcceptRejectRequestsResponse({required this.modelRequestAction});
  @override
  List<Object> get props => [modelRequestAction];
}

class AcceptRejectRequestsFailure extends AcceptRejectRequestsState {
  final ModelError errorMessage;

  const AcceptRejectRequestsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
