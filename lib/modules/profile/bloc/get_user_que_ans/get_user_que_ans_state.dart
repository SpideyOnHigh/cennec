part of 'get_user_que_ans_bloc.dart';

abstract class GetUserQueAnsState extends Equatable {
  const GetUserQueAnsState();
  @override
  List<Object> get props => [];
}

class GetUserQueAnsInitial extends GetUserQueAnsState {
  @override
  List<Object> get props => [];
}

class GetUserQueAnsLoading extends GetUserQueAnsState {
  @override
  List<Object> get props => [];
}

class GetUserQueAnsResponse extends GetUserQueAnsState {
  final ModelQuestionAnswers modelQuestionAnswers;

  const GetUserQueAnsResponse({required this.modelQuestionAnswers});
  @override
  List<Object> get props => [modelQuestionAnswers];
}

class GetUserQueAnsFailure extends GetUserQueAnsState {
  final ModelError errorMessage;

  const GetUserQueAnsFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
