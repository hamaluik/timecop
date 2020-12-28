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

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/start_of_week.dart';
import 'dart:math';

import 'Legend.dart';

class WeekdayAverages extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<Project> selectedProjects;
  final LinkedHashMap<int, LinkedHashMap<int, double>> _daysData;

  static LinkedHashMap<int, LinkedHashMap<int, double>> calculateData(
      BuildContext context,
      DateTime startDate,
      DateTime endDate,
      List<Project> selectedProjects) {
    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);

    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime(1970);
    LinkedHashMap<int, LinkedHashMap<int, double>> daySums = LinkedHashMap();
    for (int i = 0; i < 7; i++) {
      daySums.putIfAbsent(i, () => LinkedHashMap<int, double>());
    }

    for (TimerEntry timer in timers.state.timers
        .where((timer) => timer.endTime != null)
        .where((timer) => selectedProjects.any((p) => p?.id == timer.projectID))
        .where((timer) =>
            startDate != null ? timer.startTime.isAfter(startDate) : true)
        .where((timer) =>
            endDate != null ? timer.startTime.isBefore(endDate) : true)) {
      double hours =
          timer.endTime.difference(timer.startTime).inSeconds.toDouble() /
              3600.0;
      int weekday = timer.startTime.weekday;
      if (weekday == 7) weekday = 0;

      daySums[weekday].update(timer.projectID, (double sum) => sum + hours,
          ifAbsent: () => hours);

      if (timer.startTime.isBefore(firstDate)) {
        firstDate = timer.startTime;
      }
      if (timer.startTime.isAfter(lastDate)) {
        lastDate = timer.startTime;
      }
    }

    // adjust first date and last date to match the start and end of the week
    firstDate = firstDate.startOfWeek();
    lastDate = lastDate.startOfWeek().add(Duration(days: 7));

    int totalDays = DateTime(lastDate.year, lastDate.month, lastDate.day)
        .difference(DateTime(firstDate.year, firstDate.month, firstDate.day))
        .inDays;
    double totalWeeks = totalDays.toDouble() / 7.0;
    if (totalDays > 0) {
      for (int i = 0; i < 7; i++) {
        daySums[i].updateAll((int _project, double sum) => sum / totalWeeks);
      }
    }

    return daySums;
  }

  WeekdayAverages(BuildContext context,
      {Key key,
      @required this.startDate,
      @required this.endDate,
      @required this.selectedProjects})
      : assert(selectedProjects != null),
        _daysData =
            calculateData(context, startDate, endDate, selectedProjects),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);

    double maxY = _daysData.values.fold(
        0.0,
        (osum, day) =>
            max(osum, day.values.fold(0.0, (isum, v) => max(isum, v))));
    maxY = ((maxY ~/ 2) + 1) * 2.0 + 2.0;

    return Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              key: Key("weekdayAverages"),
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Theme.of(context).cardColor,
                          getTooltipItem: (BarChartGroupData group,
                                  int groupIndex,
                                  BarChartRodData rod,
                                  int rodIndex) =>
                              BarTooltipItem(
                                  L10N
                                      .of(context)
                                      .tr
                                      .nHours(rod.y.toStringAsFixed(1)),
                                  Theme.of(context).textTheme.bodyText2))),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  gridData: FlGridData(
                    show: true,
                  ),
                  titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (_) =>
                            Theme.of(context).textTheme.bodyText2,
                      ),
                      bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (_) =>
                              Theme.of(context).textTheme.bodyText2,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'S';
                              case 1:
                                return 'M';
                              case 2:
                                return 'T';
                              case 3:
                                return 'W';
                              case 4:
                                return 'T';
                              case 5:
                                return 'F';
                              case 6:
                                return 'S';
                              default:
                                return '';
                            }
                          })),
                  barGroups: List.generate(7, (i) => i)
                      .map((day) =>
                          BarChartGroupData(x: day, barRods: <BarChartRodData>[
                            BarChartRodData(
                              colors: [Theme.of(context).disabledColor],
                              width: 22,
                              y: _daysData[day].entries.fold(
                                  0.0,
                                  (double sum, MapEntry<int, double> entry) =>
                                      sum + entry.value),
                              rodStackItems:
                                  _buildDayStack(context, day, projects),
                              //backDrawRodData: BackgroundBarChartRodData(
                              //  color: Theme.of(context).chipTheme.backgroundColor,
                              //  show: true,
                              //  y: maxY,
                              //)
                            )
                          ]))
                      .toList())),
            ),
            Container(
              height: 16,
            ),
            Text(
              L10N.of(context).tr.averageDailyHours,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Legend(
                projects: selectedProjects.where((project) => _daysData.entries
                    .any((MapEntry<int, LinkedHashMap<int, double>> derp) =>
                        derp.value.keys.any((id) => project?.id == id)))),
          ],
        ));
  }

  List<BarChartRodStackItem> _buildDayStack(
      BuildContext context, int day, ProjectsBloc projects) {
    double runningY = 0;

    // sort the stack from largest to smallest
    List<List<dynamic>> derp = _daysData[day].entries.map((entry) {
      Project project = projects.state.projects
          .firstWhere((project) => project.id == entry.key, orElse: () => null);
      return <dynamic>[project, entry.value];
    }).toList();
    derp.sort((a, b) {
      double va = a[1] as double;
      double vb = b[1] as double;
      return vb.compareTo(va);
    });

    List<BarChartRodStackItem> stack = derp.map((entry) {
      Project project = entry[0] as Project;
      double value = entry[1] as double;
      return BarChartRodStackItem(runningY, runningY += value,
          project?.colour ?? Theme.of(context).disabledColor);
    }).toList();
    return stack;
  }
}
