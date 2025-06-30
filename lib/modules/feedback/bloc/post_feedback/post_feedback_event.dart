part of 'post_feedback_bloc.dart';

abstract class PostFeedbackEvent extends Equatable {
  const PostFeedbackEvent();
  @override
  List<Object> get props => [];
}

class PostFeedback extends PostFeedbackEvent {
  final String url;
  final Map<String, dynamic> body;

  const PostFeedback({required this.url, required this.body});
  @override
  List<Object> get props => [url, body];
}
