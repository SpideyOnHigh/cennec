part of 'recommendations_of_interest_bloc.dart';

abstract class RecommendationsOfInterestState extends Equatable {
  const RecommendationsOfInterestState();
  @override
  List<Object> get props => [];
}

class RecommendationsOfInterestInitial extends RecommendationsOfInterestState {
  @override
  List<Object> get props => [];
}

class RecommendationsOfInterestLoading extends RecommendationsOfInterestState {
  @override
  List<Object> get props => [];
}

class RecommendationsOfInterestResponse extends RecommendationsOfInterestState {
  final ModelRecommendationsOfInterest modelRecommendations;

  const RecommendationsOfInterestResponse({required this.modelRecommendations});
  @override
  List<Object> get props => [modelRecommendations];
}

class RecommendationsOfInterestFailure extends RecommendationsOfInterestState {
  final ModelError errorMessage;

  const RecommendationsOfInterestFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
