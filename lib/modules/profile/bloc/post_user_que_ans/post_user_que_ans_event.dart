part of 'post_user_que_ans_bloc.dart';

abstract class PostUserQueAnsEvent extends Equatable {
  const PostUserQueAnsEvent();
  @override
  List<Object> get props => [];
}

class PostUserQueAns extends PostUserQueAnsEvent {
  final Map<String,dynamic> body;
  final String url;

  const PostUserQueAns({required this.body, required this.url});
  @override
  List<Object> get props => [];
}
