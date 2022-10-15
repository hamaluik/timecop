import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timecop/data_providers/notifications/notifications_provider.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsProvider notifications;
  NotificationsBloc(this.notifications) : super(const NotificationsState()) {
    on<RequestNotificationPermissions>((event, emit) async {
      await notifications.requestPermissions();
      emit(const NotificationsState());
    });
    on<ShowNotification>((event, emit) async {
      await notifications.displayRunningTimersNotification(
          event.title, event.body);
      emit(const NotificationsState());
    });
    on<RemoveNotifications>((event, emit) async {
      await notifications.removeAllNotifications();
      emit(const NotificationsState());
    });
  }
}
