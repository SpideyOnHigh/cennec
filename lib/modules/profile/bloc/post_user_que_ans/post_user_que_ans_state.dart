part of 'post_user_que_ans_bloc.dart';

abstract class PostUserQueAnsState extends Equatable {
  const PostUserQueAnsState();
}

class PostUserQueAnsInitial extends PostUserQueAnsState {
  @override
  List<Object> get props => [];
}

class PostUserQueAnsLoading extends PostUserQueAnsState {
  @override
  List<Object> get props => [];
}

class PostUserQueAnsResponse extends PostUserQueAnsState {
  final ModelQueAnsPostResponse modelQueAnsPostResponse;

  const PostUserQueAnsResponse({required this.modelQueAnsPostResponse});
  @override
  List<Object> get props => [modelQueAnsPostResponse];
}

class PostUserQueAnsFailure extends PostUserQueAnsState {
final ModelError errorMessage;

  const PostUserQueAnsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
