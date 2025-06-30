part of 'notifications_list_bloc.dart';

abstract class NotificationsListState extends Equatable {
  const NotificationsListState();
  @override
  List<Object> get props => [];
}

class NotificationsListInitial extends NotificationsListState {
  @override
  List<Object> get props => [];
}

class NotificationsListLoading extends NotificationsListState {
  @override
  List<Object> get props => [];
}

class NotificationsListResponse extends NotificationsListState {
  final ModelNotificationContent modelNotificationContent;

  const NotificationsListResponse({required this.modelNotificationContent});
  @override
  List<Object> get props => [modelNotificationContent];
}

class NotificationsListFailure extends NotificationsListState {
  final ModelError errorMessage;

  const NotificationsListFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
