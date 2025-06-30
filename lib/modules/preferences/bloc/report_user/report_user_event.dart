part of 'report_user_bloc.dart';

abstract class ReportUserEvent extends Equatable {
  const ReportUserEvent();
  @override
  List<Object> get props => [];
}

class ReportUser extends ReportUserEvent {
  final String url;
  final Map<String, dynamic> body;

  const ReportUser({required this.url, required this.body});
  @override
  List<Object> get props => [url, body];
}
