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

import 'Legend.dart';

class ProjectBreakdown extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<Project> selectedProjects;
  ProjectBreakdown(
      {Key key,
      @required this.startDate,
      @required this.endDate,
      @required this.selectedProjects})
      : assert(selectedProjects != null),
        super(key: key);

  @override
  _ProjectBreakdownState createState() => _ProjectBreakdownState();
}

class _ProjectBreakdownState extends State<ProjectBreakdown> {
  int _touchedIndex = -1;

  static LinkedHashMap<int, double> calculateData(BuildContext context,
      DateTime startDate, DateTime endDate, List<Project> selectedProjects) {
    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);

    LinkedHashMap<int, double> projectHours = LinkedHashMap();
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
              timer.endTime.difference(timer.startTime).inSeconds.toDouble() /
                  3600,
          ifAbsent: () =>
              timer.endTime.difference(timer.startTime).inSeconds.toDouble() /
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
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);

    LinkedHashMap<int, double> _projectHours = calculateData(
        context, widget.startDate, widget.endDate, widget.selectedProjects);
    if (_projectHours.isEmpty) {
      return Container();
    }
    final double totalHours =
        _projectHours.values.fold(0.0, (double sum, double v) => sum + v);

    return Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                key: Key("projectBreakdown"),
                aspectRatio: 1,
                child: PieChart(PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          _touchedIndex = -1;
                        } else {
                          _touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    sections: List.generate(_projectHours.length, (int index) {
                      MapEntry<int, double> entry =
                          _projectHours.entries.elementAt(index);
                      Project project = projects.state.projects.firstWhere(
                          (project) => project?.id == entry.key,
                          orElse: () => null);
                      return PieChartSectionData(
                        value: entry.value,
                        color:
                            project?.colour ?? Theme.of(context).disabledColor,
                        title: _touchedIndex == index
                            ? L10N
                                    .of(context)
                                    .tr
                                    .nHours(entry.value.toStringAsFixed(1)) +
                                "\n(${(100.0 * entry.value / totalHours).toStringAsFixed(0)} %)"
                            : "",
                        titleStyle: Theme.of(context).textTheme.bodyText2,
                        radius: _touchedIndex == index ? 80 : 60,
                      );
                    }))),
              ),
            ),
            Container(
              height: 16,
            ),
            Text(
              L10N.of(context).tr.totalProjectShare,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Legend(
                projects: widget.selectedProjects.where((project) =>
                    _projectHours.keys.any((id) => project?.id == id))),
          ],
        ));
  }
}
