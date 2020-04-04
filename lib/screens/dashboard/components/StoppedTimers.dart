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
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/models/project_description_pair.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timecop/screens/dashboard/components/GroupedStoppedTimersRow.dart';
import 'StoppedTimerRow.dart';

class DayGrouping {
  final DateTime date;
  List<TimerEntry> entries = [];
  static DateFormat _dateFormat = DateFormat.yMMMMEEEEd();

  DayGrouping(this.date);

  Widget rows(BuildContext context) {
    Duration runningTotal = Duration(seconds: entries.fold(0, (int sum, TimerEntry t) => sum + t.endTime.difference(t.startTime).inSeconds));

    LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>> pairedEntries = LinkedHashMap();
    for(TimerEntry entry in entries) {
      ProjectDescriptionPair pair = ProjectDescriptionPair(entry.projectID, entry.description);
      if(pairedEntries.containsKey(pair)) {
        pairedEntries[pair].add(entry);
      }
      else {
        pairedEntries[pair] = <TimerEntry>[entry];
      }
    }

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
                  Text(
                    _dateFormat.format(date),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700
                    )
                  ),
                  Text(
                    TimerEntry.formatDuration(runningTotal),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: "FiraMono",
                    )
                  )
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ].followedBy(
        pairedEntries.values.map((timers) {
          if(timers.length > 1) {
            return GroupedStoppedTimersRow(timers: timers);
          }
          else {
            return StoppedTimerRow(timer: timers[0]);
          }
        })
      ).toList(),
    );
  }
}

class StoppedTimers extends StatelessWidget {
  const StoppedTimers({Key key}) : super(key: key);

  static List<DayGrouping> groupDays(List<DayGrouping> days, TimerEntry timer) {
    bool newDay = days.isEmpty|| !days.any((DayGrouping day) => day.date.year == timer.startTime.year && day.date.month == timer.startTime.month && day.date.day == timer.startTime.day);
    if(newDay) {
      days.add(
        DayGrouping(
          DateTime(
            timer.startTime.year,
            timer.startTime.month,
            timer.startTime.day,
          )
        )
      );
    }
    days.firstWhere((DayGrouping day) => day.date.year == timer.startTime.year && day.date.month == timer.startTime.month && day.date.day == timer.startTime.day).entries.add(timer);

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimersBloc, TimersState>(
      builder: (BuildContext context, TimersState timersState) {
        return BlocBuilder<DashboardBloc, DashboardState>(
          builder: (BuildContext context, DashboardState dashboardState) {
            var timers = timersState.timers.reversed
              .where((timer) => timer.endTime != null);
            if(dashboardState.searchString != null) {
              print('search string: ${dashboardState.searchString}');
              timers = timers
                .where((timer) => timer.description?.toLowerCase()?.startsWith(dashboardState.searchString.toLowerCase()) ?? true);
            }

            List<DayGrouping> days = timers.fold(<DayGrouping>[], groupDays);

            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (BuildContext context, int index) => days[index].rows(context),
            );
          },
        );
      },
    );
  }
}