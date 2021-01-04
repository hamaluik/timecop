import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timecop/data_providers/notifications/notifications_provider.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsProvider notifications;
  NotificationsBloc(this.notifications);

  @override
  NotificationsState get initialState => NotificationsState();

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is RequestNotificationPermissions) {
      await notifications.requestPermissions();
      yield NotificationsState();
    } else if (event is ShowNotification) {
      await notifications.displayRunningTimersNotification(
          event.title, event.body);
      yield NotificationsState();
    } else if (event is RemoveNotifications) {
      await notifications.removeAllNotifications();
      yield NotificationsState();
    }
  }
}
