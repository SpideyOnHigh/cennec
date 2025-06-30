part of 'get_interests_lists_bloc.dart';

abstract class GetInterestsListsState extends Equatable {
  const GetInterestsListsState();
  @override
  List<Object> get props => [];
}

class GetInterestsListsInitial extends GetInterestsListsState {
  @override
  List<Object> get props => [];
}

class GetInterestsListsLoading extends GetInterestsListsState {
  @override
  List<Object> get props => [];
}

class GetInterestsListsResponse extends GetInterestsListsState {
  final ModelInterestsList modelInterestsList;

  const GetInterestsListsResponse({required this.modelInterestsList});
  @override
  List<Object> get props => [modelInterestsList];
}

class GetInterestsListsFailure extends GetInterestsListsState {
  final ModelError errorMessage;

  const GetInterestsListsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
