part of 'send_request_bloc.dart';

abstract class SendRequestEvent extends Equatable {
  const SendRequestEvent();
  @override
  List<Object> get props => [];
}

class SendRequest extends SendRequestEvent {
  final Map<String, dynamic> body;
  final String url;

  const SendRequest({required this.body, required this.url});

  @override
  List<Object> get props => [body, url];
}
