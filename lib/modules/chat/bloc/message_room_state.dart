part of 'message_room_bloc.dart';

abstract class MessageRoomState extends Equatable {
  const MessageRoomState();
}

class MessageRoomLoading extends MessageRoomState {
  @override
  List<Object> get props => [];
}class MessageRoomInitial extends MessageRoomState {
  @override
  List<Object> get props => [];
}

class MessageRoomFailure extends MessageRoomState {
  final ModelError errorMessage;

  const MessageRoomFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class MessageRoomSuccess extends MessageRoomState {
  final  MessageRoomResponse response;

  const MessageRoomSuccess({required this.response});
  @override
  List<Object> get props => [response];
}

