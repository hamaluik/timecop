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
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

class TimeTable extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<Project> selectedProjects;
  const TimeTable(
      {Key key,
      @required this.startDate,
      @required this.endDate,
      @required this.selectedProjects})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
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
    final double totalHours =
        projectHours.values.fold(0.0, (double sum, double v) => sum + v);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: ListView(
        key: Key("timeTable"),
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(L10N.of(context).tr.project,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                flex: 1,
                child: Text(L10N.of(context).tr.hours,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ],
          ),
          Divider(
              thickness: 2.0,
              color: Theme.of(context).textTheme.bodyText2.color),
        ].followedBy(projectHours.entries.map((MapEntry<int, double> entry) {
          Project project = projects.state.projects.firstWhere(
              (project) => project?.id == entry.key,
              orElse: () => null);
          return Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ProjectColour(
                          mini: true,
                          project: project,
                        ),
                        Container(width: 4),
                        Text(project?.name ?? L10N.of(context).tr.noProject,
                            style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(entry.value.toStringAsFixed(1),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ],
              ));
        })).followedBy(<Widget>[
          projectHours.isEmpty
              ? Container()
              : Divider(
                  thickness: 1.0,
                  color: Theme.of(context).textTheme.bodyText2.color),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(L10N.of(context).tr.total,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
              Expanded(
                flex: 1,
                child: Text(totalHours.toStringAsFixed(1),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
            ],
          )
        ]).toList(),
      ),
    );
  }
}
