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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class NotificationsProvider {
  final FlutterLocalNotificationsPlugin _notif;
  NotificationsProvider(this._notif) : assert(_notif != null);

  static Future<NotificationsProvider> load() async {
    FlutterLocalNotificationsPlugin notif = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await notif.initialize(initializationSettings);

    return NotificationsProvider(notif);
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      bool result = await _notif
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(sound: true, alert: true, badge: true) ??
          false;
      return result;
    } else {
      return true;
    }
  }

  Future<void> displayRunningTimersNotification(
      String title, String body) async {
    print("displaying notification");
    if (!await requestPermissions()) {
      print("no permissions, quitting");
      return;
    }

    const IOSNotificationDetails ios = IOSNotificationDetails(
      presentAlert: true,
      presentSound: false,
      badgeNumber: null,
    );

    const AndroidNotificationDetails android = AndroidNotificationDetails(
        "ca.hamaluik.timecop.runningtimersnotification",
        "Running Timers",
        "Notification indicating that timers are currently running",
        priority: Priority.low,
        importance: Importance.low,
        showWhen: true);

    NotificationDetails details =
        NotificationDetails(iOS: ios, android: android);

    await _notif.show(0, title, body, details);
  }

  Future<void> removeAllNotifications() async {
    await _notif.cancelAll();
  }
}
