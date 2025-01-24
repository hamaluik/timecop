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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timecop/blocs/locale/locale_bloc.dart';
import 'package:timecop/blocs/notifications/notifications_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/theme/theme_bloc.dart';
import 'package:timecop/l10n.dart';

import 'components/locale_options.dart';
import 'components/theme_options.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bool _switchValue = false;
  // bool _notificationPermissionGranted = false;

  void requestAndroidNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;
    bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    if ((result != null && !result) && status.isDenied) {
      if (context.mounted) {
        dialogNotificationPermission(context);
      }
    }
    // else if(status.isGranted || result!){
    //   _notificationPermissionGranted = true;
    // }
  }

  Future<void> dialogNotificationPermission(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10N.of(context).tr.notificationPermissionRequired),
          content: Text(L10N.of(context).tr.notificationPermissionDialogBody),
          actions: [
            TextButton(
              child: Text(L10N.of(context).tr.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(L10N.of(context).tr.settings),
              onPressed: () => openAppSettings(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final localeBloc = BlocProvider.of<LocaleBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(L10N.of(context).tr.settings),
        ),
        body: ListView(
          children: <Widget>[
            ThemeOptions(
              bloc: themeBloc,
            ),
            LocaleOptions(
              bloc: localeBloc,
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title: Text(L10N.of(context).tr.groupTimers),
                value: settings.groupTimers,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(groupTimers: value)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title: Text(L10N.of(context).tr.showProjectNames),
                value: settings.showProjectNames,
                onChanged: (bool value) => settingsBloc
                    .add(SetBoolValueEvent(showProjectNames: value)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title: Text(L10N.of(context).tr.collapseDays),
                value: settings.collapseDays,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(collapseDays: value)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title: Text(L10N.of(context).tr.autocompleteDescription),
                value: settings.autocompleteDescription,
                onChanged: (bool value) => settingsBloc
                    .add(SetBoolValueEvent(autocompleteDescription: value)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title: Text(L10N.of(context).tr.defaultFilterStartDateToMonday),
                value: settings.defaultFilterStartDateToMonday,
                onChanged: (bool value) => settingsBloc.add(
                    SetBoolValueEvent(defaultFilterStartDateToMonday: value)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settings) {
                  return ListTile(
                    title: Text(L10N.of(context).tr.defaultFilterDays),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      settings.defaultFilterDays == -1
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text("--"))
                          : Text(settings.defaultFilterDays.toString()),
                      if (settings.defaultFilterDays != -1)
                        IconButton(
                          tooltip: L10N.of(context).tr.remove,
                          icon: const Icon(FontAwesomeIcons.circleMinus),
                          onPressed: () {
                            settingsBloc.add(const SetDefaultFilterDays(null));
                          },
                        )
                    ]),
                    onTap: () async {
                      int tempDays = settings.defaultFilterDays > 0
                          ? settings.defaultFilterDays
                          : 30;
                      int? days = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                content: NumberPicker(
                                  minValue: 1,
                                  maxValue: 365,
                                  onChanged: (int value) {
                                    setState(() => tempDays = value);
                                  },
                                  value: tempDays,
                                  infiniteLoop: true,
                                  haptics: true,
                                ),
                                title:
                                    Text(L10N.of(context).tr.defaultFilterDays),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(L10N.of(context).tr.cancel)),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, tempDays);
                                      },
                                      child: Text(L10N.of(context).tr.ok))
                                ],
                              );
                            });
                          });
                      if (days != null) {
                        settingsBloc.add(SetDefaultFilterDays(days));
                      }
                    },
                  );
                }),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title: Text(L10N.of(context).tr.oneTimerAtATime),
                value: settings.oneTimerAtATime,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(oneTimerAtATime: value)),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (Platform.isIOS || Platform.isAndroid)
              BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settings) =>
                    SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.showBadgeCounts),
                  value: settings.showBadgeCounts,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(showBadgeCounts: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title:
                    Text(L10N.of(context).tr.enableRunningTimersNotification),
                value: settings.showRunningTimersAsNotifications,
                // value: _switchValue,

                onChanged: (bool value) {
                  if (value) {
                    BlocProvider.of<NotificationsBloc>(context)
                        .add(const RequestNotificationPermissions());
                    if (Platform.isAndroid) {
                      requestAndroidNotificationPermission(context);
                    }
                  }
                  settingsBloc.add(SetBoolValueEvent(
                      showRunningTimersAsNotifications: value));
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile.adaptive(
                title:
                    Text(L10N.of(context).tr.nagAboutMissingTimer),
                value: settings.nagAboutMissingTimer,
                // value: _switchValue,

                onChanged: (bool value) {
                  if (value) {
                    BlocProvider.of<NotificationsBloc>(context)
                        .add(const RequestNotificationPermissions());
                    if (Platform.isAndroid) {
                      requestAndroidNotificationPermission(context);
                    }
                  }
                  settingsBloc.add(SetBoolValueEvent(
                      nagAboutMissingTimer: value));
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ));
  }
}
