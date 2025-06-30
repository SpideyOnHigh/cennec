part of 'get_recommendations_bloc.dart';

abstract class GetRecommendationsEvent extends Equatable {
  const GetRecommendationsEvent();
}

class GetRecommendations extends GetRecommendationsEvent {
  final String url;

  const GetRecommendations({required this.url});
  @override
  List<Object> get props => [url];
}
