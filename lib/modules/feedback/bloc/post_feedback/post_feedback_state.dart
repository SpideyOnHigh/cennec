part of 'post_feedback_bloc.dart';

abstract class PostFeedbackState extends Equatable {
  const PostFeedbackState();
}

class PostFeedbackInitial extends PostFeedbackState {
  @override
  List<Object> get props => [];
}

class PostFeedbackLoading extends PostFeedbackState {
  @override
  List<Object> get props => [];
}

class PostFeedbackResponse extends PostFeedbackState {
  final ModelFeedbackResponse modelFeedbackResponse;

  const PostFeedbackResponse({required this.modelFeedbackResponse});
  @override
  List<Object> get props => [modelFeedbackResponse];
}

class PostFeedbackFailure extends PostFeedbackState {
  final ModelError errorMessage;

  const PostFeedbackFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
