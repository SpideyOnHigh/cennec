part of 'report_user_bloc.dart';

abstract class ReportUserState extends Equatable {
  const ReportUserState();
  @override
  List<Object> get props => [];
}

class ReportUserInitial extends ReportUserState {
  @override
  List<Object> get props => [];
}

class ReportUserLoading extends ReportUserState {
  @override
  List<Object> get props => [];
}

class ReportUserResponse extends ReportUserState {
  final ModelReport modelReport;

  const ReportUserResponse({required this.modelReport});
  @override
  List<Object> get props => [modelReport];
}

class ReportUserFailure extends ReportUserState {
  final ModelError errorMessage;

  const ReportUserFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
