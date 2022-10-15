// Copyright 2020 Kenton Hamaluik
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
