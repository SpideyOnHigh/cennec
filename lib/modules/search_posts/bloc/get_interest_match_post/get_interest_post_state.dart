
part of 'get_interest_post_bloc.dart';

abstract class GetInterestMatchesState extends Equatable {
  const GetInterestMatchesState();
  @override
  List<Object> get props => [];
}

class GetInterestMatchesInitial extends GetInterestMatchesState {
  @override
  List<Object> get props => [];
}

class GetInterestMatchesLoading extends GetInterestMatchesState {
  @override
  List<Object> get props => [];
}

class GetInterestMatchesResponse extends GetInterestMatchesState {
  final ModelSimilarPosts modelInterestMatches;

  const GetInterestMatchesResponse({required this.modelInterestMatches});
  @override
  List<Object> get props => [modelInterestMatches];
}

class GetInterestMatchesFailure extends GetInterestMatchesState {
  final ModelError errorMessage;

  const GetInterestMatchesFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}