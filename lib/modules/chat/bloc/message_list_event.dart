part of 'message_list_bloc.dart';

abstract class MessageListEvent extends Equatable {
  const MessageListEvent();
}
class GetMessageList extends MessageListEvent {
  final String url;

  const GetMessageList({required this.url});
  @override
  List<Object> get props => [url];
}