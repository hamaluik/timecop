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
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

class WeeklyTotals extends StatefulWidget {
  final BuildContext context;
  final DateTime startDate;
  final DateTime endDate;
  WeeklyTotals({Key key, @required this.context, @required this.startDate, @required this.endDate}) : super(key: key);

  @override
  _WeeklyTotalsState createState() => _WeeklyTotalsState(context, startDate, endDate);
}

class _WeeklyTotalsState extends State<WeeklyTotals> {
  final DateTime startDate;
  final DateTime endDate;
  final LinkedHashMap<int, LinkedHashMap<int, double>> _projectWeeklyHours;

  static DateFormat _dateFormat = DateFormat.MMMd();

  static LinkedHashMap<int, LinkedHashMap<int, double>> calculateData(BuildContext context, DateTime startDate, DateTime endDate) {
    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);

    DateTime firstDate = startDate;
    if(firstDate == null) {
      firstDate = timers.state.timers.map((timer) => timer.startTime).fold(DateTime.now(), (DateTime a, DateTime b) => a.isBefore(b) ? a : b);
    }

    LinkedHashMap<int, LinkedHashMap<int, double>> projectWeeklyHours = LinkedHashMap();
    for(
      TimerEntry timer in timers.state.timers
        .where((timer) => timer.endTime != null)
        .where((timer) => startDate != null ? timer.startTime.isAfter(startDate) : true)
        .where((timer) => endDate != null ? timer.startTime.isBefore(endDate) : true)
    ) {
      LinkedHashMap<int, double> weeklyHours = projectWeeklyHours.putIfAbsent(timer.projectID, () => LinkedHashMap());
      
      // calculate the week
      int week = timer.startTime.difference(firstDate).inDays ~/ 7;
      double hours = timer.endTime.difference(timer.startTime).inSeconds / 3600;
      weeklyHours.update(week, (double oldHours) => oldHours + hours, ifAbsent: () => hours);
    }

    return projectWeeklyHours;
  }

  _WeeklyTotalsState(BuildContext context, this.startDate, this.endDate, {Key key})
    : this._projectWeeklyHours = calculateData(context, startDate, endDate);
    
  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    DateTime firstDate = startDate;
    if(firstDate == null) {
      final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
      firstDate = timers.state.timers.map((timer) => timer.startTime).fold(DateTime.now(), (DateTime a, DateTime b) => a.isBefore(b) ? a : b);
    }

    double maxY = _projectWeeklyHours
      .values
      .fold(0, (double omax, LinkedHashMap<int, double> weeks) =>
        max(omax, weeks.values.fold(0, (double omax, double v) => max(omax, v)))
      );
    maxY = ((maxY ~/ 10) + 1) * 10.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  )
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 5.0,
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideTheChart: true,
                    tooltipBgColor: Theme.of(context).cardColor,
                    getTooltipItems: (List<LineBarSpot> spots) {
                      return spots
                        .map((LineBarSpot spot) {
                          return LineTooltipItem(
                            L10N.of(context).tr.nHours(spot.y.toStringAsFixed(1)),
                            TextStyle(
                              color: spot.bar.colors[0],
                              fontSize: Theme.of(context).textTheme.body1.fontSize,
                            )
                          );
                        })
                        .toList();
                    }
                  )
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (double v) => v.toStringAsFixed(1),
                    textStyle: Theme.of(context).textTheme.caption,
                    interval: 5.0,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    textStyle: Theme.of(context).textTheme.caption,
                    getTitles: (double dweek) {
                      int week = dweek.toInt();
                      DateTime date = firstDate.add(Duration(days: week * 7));
                      return _dateFormat.format(date).replaceAll(' ', '\n');
                    }
                  ),
                ),
                lineBarsData: _projectWeeklyHours
                  .entries
                  .map((entry) {
                    Project project = projects.state.projects.firstWhere((project) => project.id == entry.key);
                    return LineChartBarData(
                      colors: <Color>[project.colour],
                      isCurved: true,
                      barWidth: 4,
                      dotData: FlDotData(
                        dotColor: project.colour,
                      ),
                      spots: entry
                        .value
                        .entries
                        .map((dataPoint) {
                          return FlSpot(dataPoint.key.toDouble(), dataPoint.value);
                        })
                        .toList()
                    );
                  })
                  .toList()
              )
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: _projectWeeklyHours
              .entries
              .map(
                (entry) {
                  Project project = projects.state.projects.firstWhere((project) => project.id == entry.key);
                  return Chip(
                    avatar: ProjectColour(project: project,),
                    label: Text(project.name),
                  );
                }
              )
              .toList(),
          ),
          Container(height: 16,),
          Text(L10N.of(context).tr.weeklyHours, style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,),
        ],
      )
    );
  }
}