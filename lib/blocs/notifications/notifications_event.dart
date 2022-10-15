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

part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class RequestNotificationPermissions extends NotificationsEvent {
  const RequestNotificationPermissions();
  @override
  List<Object> get props => [];
}

class ShowNotification extends NotificationsEvent {
  final String? title;
  final String? body;
  const ShowNotification({this.title, this.body});
  @override
  List<Object?> get props => [title, body];
}

class RemoveNotifications extends NotificationsEvent {
  const RemoveNotifications();
  @override
  List<Object> get props => [];
}
