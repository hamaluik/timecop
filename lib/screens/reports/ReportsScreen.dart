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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/components/DateRangeTile.dart';
import 'package:timecop/components/ProjectTile.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/screens/reports/components/ProjectBreakdown.dart';
import 'package:timecop/screens/reports/components/TimeTable.dart';
import 'package:timecop/screens/reports/components/WeekdayAverages.dart';
import 'package:timecop/screens/reports/components/WeeklyTotals.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Project?> selectedProjects = [];

  @override
  void initState() {
    super.initState();
    final projects = BlocProvider.of<ProjectsBloc>(context);
    selectedProjects = <Project?>[null]
        .followedBy(projects.state.projects
            .where((p) => !p.archived)
            .map((p) => Project.clone(p)))
        .toList();

    final settings = BlocProvider.of<SettingsBloc>(context);
    _startDate = settings.getFilterStartDate();
  }

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(L10N.of(context).tr.reports),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: Platform.isLinux || Platform.isMacOS
                          ? const EdgeInsets.symmetric(horizontal: 32)
                          : EdgeInsets.zero,
                      child: Builder(builder: (context) {
                        switch (index) {
                          case 0:
                            return ProjectBreakdown(
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                          case 1:
                            return WeeklyTotals(
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                          case 2:
                            return WeekdayAverages(
                              context,
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                          case 3:
                            return TimeTable(
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                        }
                        return const SizedBox();
                      }));
                },
                itemCount: 4,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Theme.of(context).disabledColor,
                  activeColor: Theme.of(context).colorScheme.primary,
                )),
                control: Platform.isLinux || Platform.isMacOS
                    ? SwiperControl(
                        iconPrevious: Icons.arrow_back_ios_new,
                        iconNext: Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onSurface)
                    : null,
              ),
            ),
            DateRangeTile(
                startDate: _startDate,
                endDate: _endDate,
                onStartChosen: (DateTime? dt) =>
                    setState(() => _startDate = dt),
                onEndChosen: (DateTime? dt) => setState(() => _endDate = dt)),
            ProjectTile(
              projects: projectsBloc.state.projects.where((p) => !p.archived),
              isEnabled: (project) =>
                  selectedProjects.any((p) => p?.id == project?.id),
              onToggled: (project) => setState(() {
                if (selectedProjects.any((p) => p?.id == project?.id)) {
                  selectedProjects.removeWhere((p) => p?.id == project?.id);
                } else {
                  selectedProjects.add(project);
                }
              }),
              onNoneSelected: () => setState(() {
                selectedProjects.clear();
              }),
              onAllSelected: () => selectedProjects = <Project?>[null]
                  .followedBy(projectsBloc.state.projects
                      .where((p) => !p.archived)
                      .map((p) => Project.clone(p)))
                  .toList(),
            ),
          ],
        ));
  }
}
