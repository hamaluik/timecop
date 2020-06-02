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

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/models/project_description_pair.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timecop/screens/dashboard/components/CollapsibleDayGrouping.dart';
import 'package:timecop/screens/dashboard/components/GroupedStoppedTimersRow.dart';
import 'StoppedTimerRow.dart';

class DayGrouping {
  final DateTime date;
  List<TimerEntry> entries = [];
  static final DateFormat _dateFormat = DateFormat.yMMMMEEEEd();

  DayGrouping(this.date);

  Widget rows(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    Duration runningTotal = Duration(
        seconds: entries.fold(
            0,
            (int sum, TimerEntry t) =>
                sum + t.endTime.difference(t.startTime).inSeconds));

    LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>> pairedEntries =
        LinkedHashMap();
    for (TimerEntry entry in entries) {
      ProjectDescriptionPair pair =
          ProjectDescriptionPair(entry.projectID, entry.description);
      if (pairedEntries.containsKey(pair)) {
        pairedEntries[pair].add(entry);
      } else {
        pairedEntries[pair] = <TimerEntry>[entry];
      }
    }

    Iterable<Widget> theDaysTimers = pairedEntries.values.map((timers) {
      if (settingsBloc.state.groupTimers) {
        if (timers.length > 1) {
          return <Widget>[GroupedStoppedTimersRow(timers: timers)];
        } else {
          return <Widget>[StoppedTimerRow(timer: timers[0])];
        }
      } else {
        return timers.map((t) => StoppedTimerRow(timer: t)).toList();
      }
    }).expand((l) => l);

    if (settingsBloc.state.collapseDays) {
      return CollapsibleDayGrouping(
        date: date,
        totalTime: runningTotal,
        children: theDaysTimers,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(_dateFormat.format(date),
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w700)),
                    Text(TimerEntry.formatDuration(runningTotal),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: "FiraMono",
                        ))
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ].followedBy(theDaysTimers).toList(),
      );
    }
  }
}

class StoppedTimers extends StatelessWidget {
  const StoppedTimers({Key key}) : super(key: key);

  static List<DayGrouping> groupDays(List<DayGrouping> days, TimerEntry timer) {
    bool newDay = days.isEmpty ||
        !days.any((DayGrouping day) =>
            day.date.year == timer.startTime.year &&
            day.date.month == timer.startTime.month &&
            day.date.day == timer.startTime.day);
    if (newDay) {
      days.add(DayGrouping(DateTime(
        timer.startTime.year,
        timer.startTime.month,
        timer.startTime.day,
      )));
    }
    days
        .firstWhere((DayGrouping day) =>
            day.date.year == timer.startTime.year &&
            day.date.month == timer.startTime.month &&
            day.date.day == timer.startTime.day)
        .entries
        .add(timer);

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimersBloc, TimersState>(
      builder: (BuildContext context, TimersState timersState) {
        return BlocBuilder<DashboardBloc, DashboardState>(
          builder: (BuildContext context, DashboardState dashboardState) {
            // start our list of timers
            var timers = timersState.timers.reversed
                .where((timer) => timer.endTime != null);

            // filter based on filters
            if (dashboardState.filterStart != null) {
              timers = timers.where((timer) =>
                  timer.startTime.isAfter(dashboardState.filterStart));
            }
            if (dashboardState.filterEnd != null) {
              timers = timers.where((timer) =>
                  timer.startTime.isBefore(dashboardState.filterEnd));
            }

            // filter based on selected projects
            timers = timers.where((t) =>
                !dashboardState.hiddenProjects.any((p) => p == t.projectID));

            // filter based on search
            if (dashboardState.searchString != null) {
              timers = timers.where((timer) {
                // allow searching using a regex if surrounded by `/` and `/`
                if (dashboardState.searchString.length > 2 &&
                    dashboardState.searchString.startsWith("/") &&
                    dashboardState.searchString.endsWith("/")) {
                  return timer.description?.contains(RegExp(
                          dashboardState.searchString.substring(
                              1, dashboardState.searchString.length - 1))) ??
                      true;
                } else {
                  return timer.description?.toLowerCase()?.contains(
                          dashboardState.searchString.toLowerCase()) ??
                      true;
                }
              });
            }

            List<DayGrouping> days = timers.fold(<DayGrouping>[], groupDays);

            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (BuildContext context, int index) =>
                  days[index].rows(context),
            );
          },
        );
      },
    );
  }
}
