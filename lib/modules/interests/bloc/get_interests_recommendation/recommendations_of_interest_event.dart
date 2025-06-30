part of 'recommendations_of_interest_bloc.dart';

 class RecommendationsOfInterestEvent extends Equatable {
  const RecommendationsOfInterestEvent();
  @override
  List<Object> get props => [];
 }

 class RecommendationsOfInterest extends RecommendationsOfInterestEvent {
   final String url;
  const RecommendationsOfInterest({required this.url});
   @override
   List<Object> get props => [url];

}
