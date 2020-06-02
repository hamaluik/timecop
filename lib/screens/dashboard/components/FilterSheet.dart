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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class FilterSheet extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  static final DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy");
  const FilterSheet({Key key, @required this.dashboardBloc})
      : assert(dashboardBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (BuildContext context, DashboardState state) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            ExpansionTile(
              title: Text(L10N.of(context).tr.filter,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700)),
              initiallyExpanded: true,
              children: <Widget>[
                Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.15,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.calendar),
                    title: Text(L10N.of(context).tr.from),
                    trailing: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                      child: Text(state.filterStart == null
                          ? "—"
                          : _dateFormat.format(state.filterStart)),
                    ),
                    onTap: () async {
                      await DatePicker.showDatePicker(context,
                          currentTime: state.filterStart,
                          onChanged: (DateTime dt) => dashboardBloc.add(
                              FilterStartChangedEvent(
                                  DateTime(dt.year, dt.month, dt.day))),
                          onConfirm: (DateTime dt) => dashboardBloc.add(
                              FilterStartChangedEvent(
                                  DateTime(dt.year, dt.month, dt.day))),
                          theme: DatePickerTheme(
                            cancelStyle: Theme.of(context).textTheme.button,
                            doneStyle: Theme.of(context).textTheme.button,
                            itemStyle: Theme.of(context).textTheme.bodyText2,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          ));
                    },
                  ),
                  secondaryActions: state.filterStart == null
                      ? <Widget>[]
                      : <Widget>[
                          IconSlideAction(
                            color: Theme.of(context).errorColor,
                            foregroundColor:
                                Theme.of(context).accentIconTheme.color,
                            icon: FontAwesomeIcons.minusCircle,
                            onTap: () => dashboardBloc
                                .add(FilterStartChangedEvent(null)),
                          )
                        ],
                ),
                Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.15,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.calendar),
                    title: Text(L10N.of(context).tr.to),
                    trailing: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                      child: Text(state.filterEnd == null
                          ? "—"
                          : _dateFormat.format(state.filterEnd)),
                    ),
                    onTap: () async {
                      await DatePicker.showDatePicker(context,
                          currentTime: state.filterEnd,
                          onChanged: (DateTime dt) => dashboardBloc.add(
                              FilterEndChangedEvent(DateTime(
                                  dt.year, dt.month, dt.day, 23, 59, 59, 999))),
                          onConfirm: (DateTime dt) => dashboardBloc.add(
                              FilterEndChangedEvent(DateTime(
                                  dt.year, dt.month, dt.day, 23, 59, 59, 999))),
                          theme: DatePickerTheme(
                            cancelStyle: Theme.of(context).textTheme.button,
                            doneStyle: Theme.of(context).textTheme.button,
                            itemStyle: Theme.of(context).textTheme.bodyText2,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          ));
                    },
                  ),
                  secondaryActions: state.filterEnd == null
                      ? <Widget>[]
                      : <Widget>[
                          IconSlideAction(
                            color: Theme.of(context).errorColor,
                            foregroundColor:
                                Theme.of(context).accentIconTheme.color,
                            icon: FontAwesomeIcons.minusCircle,
                            onTap: () =>
                                dashboardBloc.add(FilterEndChangedEvent(null)),
                          )
                        ],
                ),
              ],
            ),
            ExpansionTile(
              title: Text(L10N.of(context).tr.projects,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700)),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(L10N.of(context).tr.selectNone),
                      onPressed: () => dashboardBloc.add(
                          FilterProjectsChangedEvent(<int>[null]
                              .followedBy(
                                  projectsBloc.state.projects.map((p) => p.id))
                              .toList())),
                    ),
                    RaisedButton(
                      child: Text(L10N.of(context).tr.selectAll),
                      onPressed: () => dashboardBloc
                          .add(FilterProjectsChangedEvent(<int>[])),
                    ),
                  ],
                ),
              ]
                  .followedBy(<Project>[null]
                      .followedBy(projectsBloc.state.projects)
                      .map((project) => CheckboxListTile(
                            secondary: ProjectColour(
                              project: project,
                            ),
                            title: Text(
                                project?.name ?? L10N.of(context).tr.noProject),
                            value: !state.hiddenProjects
                                .any((p) => p == project?.id),
                            activeColor: Theme.of(context).accentColor,
                            onChanged: (_) {
                              List<int> hiddenProjects =
                                  state.hiddenProjects.map((p) => p).toList();
                              if (state.hiddenProjects
                                  .any((p) => p == project?.id)) {
                                hiddenProjects
                                    .removeWhere((p) => p == project?.id);
                              } else {
                                hiddenProjects.add(project.id);
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
