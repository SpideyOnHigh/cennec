part of 'notifications_list_bloc.dart';

abstract class NotificationsListEvent extends Equatable {
  const NotificationsListEvent();
  @override
  List<Object> get props => [];
}

class NotificationsList extends NotificationsListEvent {
  final String url;

  const NotificationsList({required this.url});
  @override
  List<Object> get props => [url];
}
