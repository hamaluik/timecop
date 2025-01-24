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

import 'package:collection/collection.dart' show IterableExtension;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/start_of_week.dart';
import 'package:timecop/themes.dart';

import 'Legend.dart';

class WeeklyTotals extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Project?> selectedProjects;
  const WeeklyTotals(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.selectedProjects})
      : super(key: key);

  @override
  State<WeeklyTotals> createState() => _WeeklyTotalsState();
}

class _WeeklyTotalsState extends State<WeeklyTotals> {
  static LinkedHashMap<int?, LinkedHashMap<int, double>> calculateData(
      BuildContext context,
      DateTime? startDate,
      DateTime? endDate,
      List<Project?> selectedProjects) {
    final timers = BlocProvider.of<TimersBloc>(context);

    DateTime? firstDate = startDate;
    firstDate ??= timers.state.timers.map((timer) => timer.startTime).fold(
        DateTime.now(),
        ((DateTime? prev, DateTime cur) =>
            prev?.isBefore(cur) ?? false ? prev : cur));
    firstDate = firstDate!.startOfWeek();

    LinkedHashMap<int?, LinkedHashMap<int, double>> projectWeeklyHours =
        LinkedHashMap();
    for (TimerEntry timer in timers.state.timers
        .where((timer) => timer.endTime != null)
        .where((timer) => selectedProjects.any((p) => p?.id == timer.projectID))
        .where((timer) =>
            startDate != null ? timer.startTime.isAfter(startDate) : true)
        .where((timer) =>
            endDate != null ? timer.startTime.isBefore(endDate) : true)) {
      LinkedHashMap<int, double> weeklyHours = projectWeeklyHours.putIfAbsent(
          timer.projectID, () => LinkedHashMap());

      // calculate the week
      int week = timer.startTime.difference(firstDate).inDays ~/ 7;
      double hours =
          timer.endTime!.difference(timer.startTime).inSeconds / 3600;
      weeklyHours.update(week, (double oldHours) => oldHours + hours,
          ifAbsent: () => hours);
    }

    return projectWeeklyHours;
  }

  @override
  Widget build(BuildContext context) {
    final projects = BlocProvider.of<ProjectsBloc>(context);
    final dateFormat = DateFormat.MMMd();

    final theme = Theme.of(context);

    DateTime? firstDate = widget.startDate;
    if (firstDate == null) {
      final timers = BlocProvider.of<TimersBloc>(context);
      firstDate = timers.state.timers.map((timer) => timer.startTime).fold(
          DateTime.now(),
          ((DateTime? prev, DateTime cur) =>
              prev?.isBefore(cur) ?? false ? prev : cur));
    }
    firstDate = firstDate!.startOfWeek();

    LinkedHashMap<int?, LinkedHashMap<int, double>> projectWeeklyHours =
        calculateData(
            context, widget.startDate, widget.endDate, widget.selectedProjects);
    double maxY = projectWeeklyHours.values.fold(
        0,
        (double omax, LinkedHashMap<int, double> weeks) => max(omax,
            weeks.values.fold(0, (double omax, double v) => max(omax, v))));
    maxY = ((maxY ~/ 5) + 1) * 5.0 + 5.0;

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              key: const Key("weeklyTotals"),
              child: LineChart(LineChartData(
                  minY: 0,
                  maxY: maxY,
                  borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.textTheme.bodyMedium!.color!,
                        ),
                        left: BorderSide(
                          color: theme.textTheme.bodyMedium!.color!,
                        ),
                      )),
                  gridData: const FlGridData(
                    show: true,
                    horizontalInterval: 5.0,
                  ),
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: theme.cardColor,
                          getTooltipItems: (List<LineBarSpot> spots) {
                            return spots.map((LineBarSpot spot) {
                              return LineTooltipItem(
                                  L10N
                                      .of(context)
                                      .tr
                                      .nHours(spot.y.toStringAsFixed(1)),
                                  theme.textTheme.bodyMedium!.copyWith(
                                    color: spot.bar.color,
                                  ));
                            }).toList();
                          })),
                  titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double v, _) => Text(
                          v.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall,
                        ),
                        interval: 5.0,
                      )),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            reservedSize: 35,
                            showTitles: true,
                            getTitlesWidget: (double dweek, _) {
                              int week = dweek.toInt();
                              DateTime date =
                                  firstDate!.add(Duration(days: week * 7));
                              return Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  dateFormat.format(date),
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            }),
                      )),
                  lineBarsData: projectWeeklyHours.entries.map((entry) {
                    Project? project = projects.state.projects
                        .firstWhereOrNull((project) => project.id == entry.key);
                    return LineChartBarData(
                        color: project?.colour ??
                            ThemeUtil.getOnBackgroundLighter(context),
                        isCurved: true,
                        barWidth: 4,
                        spots: entry.value.entries.map((dataPoint) {
                          return FlSpot(
                              dataPoint.key.toDouble(), dataPoint.value);
                        }).toList());
                  }).toList())),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              L10N.of(context).tr.weeklyHours,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Legend(
                projects: widget.selectedProjects.where((project) =>
                    projectWeeklyHours.keys.any((id) => project?.id == id))),
          ],
        ));
  }
}
