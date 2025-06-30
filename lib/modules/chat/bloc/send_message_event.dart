part of 'send_message_bloc.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();
}

class SendMessageApiEvent extends SendMessageEvent {
  final String url;
  final Map<String,dynamic> body;

  const SendMessageApiEvent({required this.url,required this.body});
  @override
  List<Object> get props => [url,body];
}
