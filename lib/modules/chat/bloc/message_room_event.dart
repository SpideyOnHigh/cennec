part of 'message_room_bloc.dart';

abstract class MessageRoomEvent extends Equatable {
  const MessageRoomEvent();
}
class GetMessageRoomData extends MessageRoomEvent {
  final String url;

  const GetMessageRoomData({required this.url});
  @override
  List<Object> get props => [url];
}
