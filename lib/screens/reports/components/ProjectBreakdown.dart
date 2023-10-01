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

import 'package:collection/collection.dart' show IterableExtension;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/themes.dart';

import 'Legend.dart';

class ProjectBreakdown extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Project?> selectedProjects;
  const ProjectBreakdown(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.selectedProjects})
      : super(key: key);

  @override
  State<ProjectBreakdown> createState() => _ProjectBreakdownState();
}

class _ProjectBreakdownState extends State<ProjectBreakdown> {
  int? _touchedIndex = -1;

  static LinkedHashMap<int?, double> calculateData(BuildContext context,
      DateTime? startDate, DateTime? endDate, List<Project?> selectedProjects) {
    final timers = BlocProvider.of<TimersBloc>(context);

    LinkedHashMap<int?, double> projectHours = LinkedHashMap();
    for (TimerEntry timer in timers.state.timers
        .where((timer) => timer.endTime != null)
        .where((timer) => selectedProjects.any((p) => p?.id == timer.projectID))
        .where((timer) =>
            startDate != null ? timer.startTime.isAfter(startDate) : true)
        .where((timer) =>
            endDate != null ? timer.startTime.isBefore(endDate) : true)) {
      projectHours.update(
          timer.projectID,
          (sum) =>
              sum +
              timer.endTime!.difference(timer.startTime).inSeconds.toDouble() /
                  3600,
          ifAbsent: () =>
              timer.endTime!.difference(timer.startTime).inSeconds.toDouble() /
              3600);
    }

    return projectHours;
  }

  @override
  void initState() {
    super.initState();
    _touchedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    final projects = BlocProvider.of<ProjectsBloc>(context);

    LinkedHashMap<int?, double> projectHours = calculateData(
        context, widget.startDate, widget.endDate, widget.selectedProjects);
    if (projectHours.isEmpty) {
      return const SizedBox();
    }
    final double totalHours =
        projectHours.values.fold(0.0, (double sum, double v) => sum + v);

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                key: const Key("projectBreakdown"),
                aspectRatio: 1,
                child: PieChart(PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    pieTouchData: PieTouchData(
                        touchCallback: (flTouchEvent, pieTouchResponse) {
                      setState(() {
                        if (flTouchEvent is FlLongPressEnd ||
                            flTouchEvent is FlPanEndEvent) {
                          _touchedIndex = -1;
                        } else {
                          _touchedIndex = pieTouchResponse
                              ?.touchedSection?.touchedSectionIndex;
                        }
                      });
                    }),
                    sections: List.generate(projectHours.length, (int index) {
                      MapEntry<int?, double> entry =
                          projectHours.entries.elementAt(index);
                      Project? project = projects.state.projects
                          .firstWhereOrNull(
                              (project) => project.id == entry.key);
                      return PieChartSectionData(
                        value: entry.value,
                        color: project?.colour ??
                            ThemeUtil.getOnBackgroundLighter(context),
                        title: _touchedIndex == index
                            ? "${L10N.of(context).tr.nHours(entry.value.toStringAsFixed(1))}\n(${(100.0 * entry.value / totalHours).toStringAsFixed(0)} %)"
                            : "",
                        titleStyle: Theme.of(context).textTheme.bodyMedium,
                        radius: _touchedIndex == index ? 80 : 60,
                      );
                    }))),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              L10N.of(context).tr.totalProjectShare,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Legend(
                projects: widget.selectedProjects.where((project) =>
                    projectHours.keys.any((id) => project?.id == id))),
          ],
        ));
  }
}
