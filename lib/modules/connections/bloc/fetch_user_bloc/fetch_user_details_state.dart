part of 'fetch_user_details_bloc.dart';

abstract class FetchUserDetailsState extends Equatable {
  const FetchUserDetailsState();
  @override
  List<Object> get props => [];
}

class FetchUserDetailsInitial extends FetchUserDetailsState {
  @override
  List<Object> get props => [];
}

class FetchUserDetailsLoading extends FetchUserDetailsState {
  @override
  List<Object> get props => [];
}

class FetchUserDetailsResponse extends FetchUserDetailsState {
  final ModelFetchUserDetail modelFetchUserDetail;

  const FetchUserDetailsResponse({required this.modelFetchUserDetail});
  @override
  List<Object> get props => [modelFetchUserDetail];
}

class FetchUserDetailsFailure extends FetchUserDetailsState {
  final ModelError errorMessage;

  const FetchUserDetailsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
