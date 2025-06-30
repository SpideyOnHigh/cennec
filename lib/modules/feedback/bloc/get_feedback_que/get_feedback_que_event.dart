part of 'get_feedback_que_bloc.dart';

abstract class GetFeedbackQueEvent extends Equatable {
  const GetFeedbackQueEvent();
  @override
  List<Object> get props => [];
}
class GetFeedbackQue extends GetFeedbackQueEvent {
  final String url;

  const GetFeedbackQue({required this.url});
  @override
  List<Object> get props => [];
}
