part of 'get_my_interests_bloc.dart';

abstract class GetMyInterestsState extends Equatable {
  const GetMyInterestsState();
}

class GetMyInterestsInitial extends GetMyInterestsState {
  @override
  List<Object> get props => [];
}

class GetMyInterestsLoading extends GetMyInterestsState {
  @override
  List<Object> get props => [];
}

class GetMyInterestsResponse extends GetMyInterestsState {
  final ModelInterestsList modelInterestsList;

  const GetMyInterestsResponse({required this.modelInterestsList});
  @override
  List<Object> get props => [modelInterestsList];
}

class GetMyInterestsFailure extends GetMyInterestsState {
  final ModelError errorMessage;

  const GetMyInterestsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
