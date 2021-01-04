part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class RequestNotificationPermissions extends NotificationsEvent {
  RequestNotificationPermissions();
  @override
  List<Object> get props => [];
}

class ShowNotification extends NotificationsEvent {
  final String title;
  final String body;
  ShowNotification({this.title, this.body});
  @override
  List<Object> get props => [title, body];
}

class RemoveNotifications extends NotificationsEvent {
  RemoveNotifications();
  @override
  List<Object> get props => [];
}
