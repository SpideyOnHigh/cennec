part of 'get_recommendations_bloc.dart';

abstract class GetRecommendationsState extends Equatable {
  const GetRecommendationsState();
  @override
  List<Object> get props => [];
}

class GetRecommendationsInitial extends GetRecommendationsState {
  @override
  List<Object> get props => [];
}

class GetRecommendationsLoading extends GetRecommendationsState {
  @override
  List<Object> get props => [];
}

class GetRecommendationsResponse extends GetRecommendationsState {
  final ModelRecommendations modelRecommendations;

  const GetRecommendationsResponse({required this.modelRecommendations});
  @override
  List<Object> get props => [modelRecommendations];
}

class GetRecommendationsFailure extends GetRecommendationsState {
  final ModelError errorMessage;

  const GetRecommendationsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
