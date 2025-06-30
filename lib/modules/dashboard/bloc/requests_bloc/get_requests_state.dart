part of 'get_requests_bloc.dart';

abstract class GetRequestsState extends Equatable {
  const GetRequestsState();
  @override
  List<Object> get props => [];
}

class GetRequestsInitial extends GetRequestsState {
  @override
  List<Object> get props => [];
}

class GetRequestsLoading extends GetRequestsState {
  @override
  List<Object> get props => [];
}

class GetRequestsResponse extends GetRequestsState {
  final ModelRequests modelRequests;

  const GetRequestsResponse({required this.modelRequests});
  @override
  List<Object> get props => [modelRequests];
}

class GetRequestsFailure extends GetRequestsState {
  final ModelError errorMessage;

  const GetRequestsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
