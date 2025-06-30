part of 'message_list_bloc.dart';

abstract class MessageListState extends Equatable {
  const MessageListState();
}

class MessageListInitial extends MessageListState {
  @override
  List<Object> get props => [];
}
class MessageListLoading extends MessageListState {
  @override
  List<Object> get props => [];
}

class MessageListFailure extends MessageListState {
  final ModelError errorMessage;

  const MessageListFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class MessageListSuccess extends MessageListState {
  final MessageListResponse modelSuccess;

  const MessageListSuccess({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}
