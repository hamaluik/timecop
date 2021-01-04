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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/locale/locale_bloc.dart';
import 'package:timecop/blocs/notifications/notifications_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/theme/theme_bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

import 'components/locale_options.dart';
import 'components/theme_options.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);
    final LocaleBloc localeBloc = BlocProvider.of<LocaleBloc>(context);
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

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
                  SwitchListTile(
                title: Text(L10N.of(context).tr.groupTimers),
                value: settings.groupTimers,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(groupTimers: value)),
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile(
                title: Text(L10N.of(context).tr.collapseDays),
                value: settings.collapseDays,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(collapseDays: value)),
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile(
                title: Text(L10N.of(context).tr.autocompleteDescription),
                value: settings.autocompleteDescription,
                onChanged: (bool value) => settingsBloc
                    .add(SetBoolValueEvent(autocompleteDescription: value)),
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile(
                title: Text(L10N.of(context).tr.defaultFilterStartDateToMonday),
                value: settings.defaultFilterStartDateToMonday,
                onChanged: (bool value) => settingsBloc.add(
                    SetBoolValueEvent(defaultFilterStartDateToMonday: value)),
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settings) {
                  if (settings.defaultFilterStartDateToMonday) {
                    return Container();
                  }

                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.15,
                    child: ListTile(
                      title: Text(L10N.of(context).tr.defaultFilterDays),
                      trailing: Text(settings.defaultFilterDays == -1
                          ? "—"
                          : settings.defaultFilterDays.toString()),
                      onTap: () async {
                        int days = await showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return NumberPickerDialog.integer(
                                minValue: 1,
                                maxValue: 365,
                                initialIntegerValue:
                                    settings.defaultFilterDays > 0
                                        ? settings.defaultFilterDays
                                        : 30,
                                title:
                                    Text(L10N.of(context).tr.defaultFilterDays),
                                infiniteLoop: true,
                                haptics: true,
                              );
                            });
                        if (days != null) {
                          settingsBloc.add(SetDefaultFilterDays(days));
                        }
                      },
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Theme.of(context).errorColor,
                        foregroundColor:
                            Theme.of(context).accentIconTheme.color,
                        icon: FontAwesomeIcons.minusCircle,
                        onTap: () {
                          settingsBloc.add(SetDefaultFilterDays(null));
                        },
                      )
                    ],
                  );
                }),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile(
                title: Text(L10N.of(context).tr.oneTimerAtATime),
                value: settings.oneTimerAtATime,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(oneTimerAtATime: value)),
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile(
                title: Text(L10N.of(context).tr.showBadgeCounts),
                value: settings.showBadgeCounts,
                onChanged: (bool value) =>
                    settingsBloc.add(SetBoolValueEvent(showBadgeCounts: value)),
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            BlocBuilder<SettingsBloc, SettingsState>(
              bloc: settingsBloc,
              builder: (BuildContext context, SettingsState settings) =>
                  SwitchListTile(
                title:
                    Text(L10N.of(context).tr.enableRunningTimersNotification),
                value: settings.showRunningTimersAsNotifications,
                onChanged: (bool value) {
                  if (value) {
                    BlocProvider.of<NotificationsBloc>(context)
                        .add(RequestNotificationPermissions());
                  }
                  settingsBloc.add(SetBoolValueEvent(
                      showRunningTimersAsNotifications: value));
                },
                activeColor: Theme.of(context).accentColor,
              ),
            ),
          ],
        ));
  }
}
