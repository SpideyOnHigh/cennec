part of 'send_message_bloc.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();
}

class SendMessageInitial extends SendMessageState {
  @override
  List<Object> get props => [];
}

class SendMessageLoading extends SendMessageState {
  @override
  List<Object> get props => [];
}

class SendMessageFailure extends SendMessageState {
  final ModelError modelError;

  const SendMessageFailure({required this.modelError});
  @override
  List<Object> get props => [modelError];
}

class SendMessageSuccess extends SendMessageState {
  final SendMessageResponse messageResponse;

  const SendMessageSuccess({required this.messageResponse});
  @override
  List<Object> get props => [messageResponse];
}
