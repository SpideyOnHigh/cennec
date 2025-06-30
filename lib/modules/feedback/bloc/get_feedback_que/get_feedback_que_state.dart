part of 'get_feedback_que_bloc.dart';

abstract class GetFeedbackQueState extends Equatable {
  const GetFeedbackQueState();
}

class GetFeedbackQueInitial extends GetFeedbackQueState {
  @override
  List<Object> get props => [];
}

class GetFeedbackQueLoading extends GetFeedbackQueState {
  @override
  List<Object> get props => [];
}

class GetFeedbackQueResponse extends GetFeedbackQueState {
  final ModelFeedbackQuestions modelFeedbackQuestions;

  const GetFeedbackQueResponse({required this.modelFeedbackQuestions});
  @override
  List<Object> get props => [modelFeedbackQuestions];
}

class GetFeedbackQueFailure extends GetFeedbackQueState {
  final ModelError errorMessage;

  const GetFeedbackQueFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
