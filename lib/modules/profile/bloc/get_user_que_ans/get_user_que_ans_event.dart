part of 'get_user_que_ans_bloc.dart';

abstract class GetUserQueAnsEvent extends Equatable {
  const GetUserQueAnsEvent();
  @override
  List<Object> get props => [];
}

class GetUserQueAns extends GetUserQueAnsEvent {
  final String url;

  const GetUserQueAns({required this.url});
  @override
  List<Object> get props => [url];
}
