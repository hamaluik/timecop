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
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class FilterSheet extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  const FilterSheet({super.key, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final dateFormat = DateFormat.yMMMEd();

    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (BuildContext context, DashboardState state) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            ExpansionTile(
              title: Text(
                L10N.of(context).tr.filter,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700),
              ),
              initiallyExpanded: true,
              children: <Widget>[
                ListTile(
                  leading: const Icon(FontAwesomeIcons.calendar),
                  title: Text(L10N.of(context).tr.from),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    state.filterStart == null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Text("--"))
                        : Text(
                            dateFormat.format(state.filterStart!),
                          ),
                    if (state.filterStart != null)
                      IconButton(
                        tooltip: L10N.of(context).tr.remove,
                        icon: const Icon(FontAwesomeIcons.circleMinus),
                        onPressed: () => dashboardBloc
                            .add(const FilterStartChangedEvent(null)),
                      ),
                  ]),
                  onTap: () async {
                    await dt.DatePicker.showDatePicker(context,
                        currentTime: state.filterStart,
                        onChanged: (DateTime dt) => dashboardBloc.add(
                            FilterStartChangedEvent(
                                DateTime(dt.year, dt.month, dt.day))),
                        onConfirm: (DateTime dt) => dashboardBloc.add(
                            FilterStartChangedEvent(
                                DateTime(dt.year, dt.month, dt.day))),
                        theme: dt.DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.labelLarge!,
                          doneStyle: Theme.of(context).textTheme.labelLarge!,
                          itemStyle: Theme.of(context).textTheme.bodyMedium!,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.calendar),
                  title: Text(L10N.of(context).tr.to),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    state.filterEnd == null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Text("--"))
                        : Text(dateFormat.format(state.filterEnd!)),
                    if (state.filterEnd != null)
                      IconButton(
                        tooltip: L10N.of(context).tr.remove,
                        icon: const Icon(FontAwesomeIcons.circleMinus),
                        onPressed: () => dashboardBloc
                            .add(const FilterEndChangedEvent(null)),
                      ),
                  ]),
                  onTap: () async {
                    await dt.DatePicker.showDatePicker(context,
                        currentTime: state.filterEnd,
                        onChanged: (DateTime dt) => dashboardBloc.add(
                            FilterEndChangedEvent(DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999))),
                        onConfirm: (DateTime dt) => dashboardBloc.add(
                            FilterEndChangedEvent(DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999))),
                        theme: dt.DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.labelLarge!,
                          doneStyle: Theme.of(context).textTheme.labelLarge!,
                          itemStyle: Theme.of(context).textTheme.bodyMedium!,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ));
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text(L10N.of(context).tr.projects,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700)),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text(L10N.of(context).tr.selectNone),
                      onPressed: () => dashboardBloc.add(
                          FilterProjectsChangedEvent(<int?>[null]
                              .followedBy(
                                  projectsBloc.state.projects.map((p) => p.id))
                              .toList())),
                    ),
                    ElevatedButton(
                      child: Text(L10N.of(context).tr.selectAll),
                      onPressed: () => dashboardBloc
                          .add(const FilterProjectsChangedEvent(<int>[])),
                    ),
                  ],
                ),
              ]
                  .followedBy(<Project?>[null]
                      .followedBy(
                          projectsBloc.state.projects.where((p) => !p.archived))
                      .map((project) => CheckboxListTile(
                            secondary: ProjectColour(
                              project: project,
                            ),
                            title: Text(
                                project?.name ?? L10N.of(context).tr.noProject),
                            value: !state.hiddenProjects
                                .any((p) => p == project?.id),
                            onChanged: (_) {
                              List<int?> hiddenProjects =
                                  state.hiddenProjects.map((p) => p).toList();
                              if (state.hiddenProjects
                                  .any((p) => p == project?.id)) {
                                hiddenProjects
                                    .removeWhere((p) => p == project?.id);
                              } else {
                                hiddenProjects.add(project?.id);
                              }
                              dashboardBloc.add(
                                  FilterProjectsChangedEvent(hiddenProjects));
                            },
                          )))
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
