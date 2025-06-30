part of 'sign_up_details_bloc.dart';

abstract class SignUpDetailsState extends Equatable {
  const SignUpDetailsState();
  @override
  List<Object> get props => [];
}

class SignUpDetailsInitial extends SignUpDetailsState {
  @override
  List<Object> get props => [];
}

class SignUpDetailsLoading extends SignUpDetailsState {
  @override
  List<Object> get props => [];
}

class SignUpDetailsResponse extends SignUpDetailsState {
  final ModelRegistration modelRegistration;

  const SignUpDetailsResponse({required this.modelRegistration});
  @override
  List<Object> get props => [modelRegistration];
}

class SignUpDetailsFailure extends SignUpDetailsState {
  final ModelError errorMessage;

  const SignUpDetailsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
