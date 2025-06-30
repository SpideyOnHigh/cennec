part of 'send_request_bloc.dart';

abstract class SendRequestState extends Equatable {
  const SendRequestState();
  @override
  List<Object> get props => [];
}

class SendRequestInitial extends SendRequestState {
  @override
  List<Object> get props => [];
}

class SendRequestLoading extends SendRequestState {
  @override
  List<Object> get props => [];
}

class SendRequestResponse extends SendRequestState {
  final ModelSendRequestResponse modelSendRequestResponse;

  const SendRequestResponse({required this.modelSendRequestResponse});
  @override
  List<Object> get props => [modelSendRequestResponse];
}

class SendRequestFailure extends SendRequestState {
  final ModelError errorMessage;

  const SendRequestFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
