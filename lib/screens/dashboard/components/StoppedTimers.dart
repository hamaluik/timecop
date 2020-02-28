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
import 'package:intl/intl.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/models/timer_entry.dart';
import 'StoppedTimerRow.dart';

class DayGrouping {
  final DateTime date;
  List<TimerEntry> entries = [];
  static DateFormat _dateFormat = DateFormat('yMMMMd');

  DayGrouping(this.date);

  Widget rows(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _dateFormat.format(date),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w700
                )
              ),
              Divider(),
            ],
          ),
        ),
      ].followedBy(
        entries.map((timer) => StoppedTimerRow(timer: timer))
      ).toList(),
    );
  }
}

class StoppedTimers extends StatelessWidget {
  const StoppedTimers({Key key}) : super(key: key);

  static List<DayGrouping> groupDays(List<DayGrouping> days, TimerEntry timer) {
    bool newDay = days.isEmpty|| timer.startTime.difference(days.last.date).inDays >= 1;
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
    days.last.entries.add(timer);

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimersBloc, TimersState>(
      builder: (BuildContext context, TimersState timersState) {
        return ListView(
          shrinkWrap: false,
          reverse: true,
          children: timersState.timers
            .where((timer) => timer.endTime != null)
            .fold(<DayGrouping>[], groupDays)
            .map((DayGrouping day) => day.rows(context)).toList(),
        );
      },
    );
  }
}