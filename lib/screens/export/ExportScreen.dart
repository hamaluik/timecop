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
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/work_types/work_types_bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/components/WorkTypeBadge.dart';
import 'package:timecop/components/exporter.dart';
import 'package:timecop/components/exporter_data.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

class ExportScreen extends StatefulWidget {
  ExportScreen({Key key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class DayGroup {
  final DateTime date;
  List<TimerEntry> timers = [];

  DayGroup(this.date) : assert(date != null);
}

class _ExportScreenState extends State<ExportScreen> {
  ExporterData _exporterData = new ExporterData();

  @override
  void initState() {
    super.initState();
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    assert(projects != null);
    _exporterData.selectedProjects = <Project>[null]
        .followedBy(projects.state.projects.map((p) => Project.clone(p)))
        .toList();

    final WorkTypesBloc workTypes = BlocProvider.of<WorkTypesBloc>(context);
    assert(workTypes != null);
    _exporterData.selectedWorkTypes = <WorkType>[null]
        .followedBy(workTypes.state.workTypes.map((p) => WorkType.clone(p)))
        .toList();

    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _exporterData.startDate = settingsBloc.getFilterStartDate();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final WorkTypesBloc workTypesBloc = BlocProvider.of<WorkTypesBloc>(context);
    final Exporter exporter =
        Exporter(context: context, exporterData: _exporterData);

    // TODO: break this into components or something so we don't have such a massively unmanageable build function

    return Scaffold(
      key: _exporterData.scaffoldKey,
      appBar: AppBar(
        title: Text(L10N.of(context).tr.export),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.database),
            onPressed: () async {
              exporter.exportDatabase();
            },
          )
        ],
      ),
      body: ListView(
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
                    child: Text(_exporterData.startDate == null
                        ? "—"
                        : ExporterData.dateFormat
                            .format(_exporterData.startDate)),
                  ),
                  onTap: () async {
                    await DatePicker.showDatePicker(context,
                        currentTime: _exporterData.startDate,
                        onChanged: (DateTime dt) => setState(() => _exporterData
                            .startDate = DateTime(dt.year, dt.month, dt.day)),
                        onConfirm: (DateTime dt) => setState(() => _exporterData
                            .startDate = DateTime(dt.year, dt.month, dt.day)),
                        theme: DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.button,
                          doneStyle: Theme.of(context).textTheme.button,
                          itemStyle: Theme.of(context).textTheme.body1,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ));
                  },
                ),
                secondaryActions: _exporterData.startDate == null
                    ? <Widget>[]
                    : <Widget>[
                        IconSlideAction(
                          color: Theme.of(context).errorColor,
                          foregroundColor:
                              Theme.of(context).accentIconTheme.color,
                          icon: FontAwesomeIcons.minusCircle,
                          onTap: () {
                            setState(() {
                              _exporterData.startDate = null;
                            });
                          },
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
                    child: Text(_exporterData.endDate == null
                        ? "—"
                        : ExporterData.dateFormat
                            .format(_exporterData.endDate)),
                  ),
                  onTap: () async {
                    await DatePicker.showDatePicker(context,
                        currentTime: _exporterData.endDate,
                        onChanged: (DateTime dt) => setState(() =>
                            _exporterData.endDate = DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                        onConfirm: (DateTime dt) => setState(() =>
                            _exporterData.endDate = DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                        theme: DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.button,
                          doneStyle: Theme.of(context).textTheme.button,
                          itemStyle: Theme.of(context).textTheme.body1,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ));
                  },
                ),
                secondaryActions: _exporterData.endDate == null
                    ? <Widget>[]
                    : <Widget>[
                        IconSlideAction(
                          color: Theme.of(context).errorColor,
                          foregroundColor:
                              Theme.of(context).accentIconTheme.color,
                          icon: FontAwesomeIcons.minusCircle,
                          onTap: () {
                            setState(() {
                              _exporterData.endDate = null;
                            });
                          },
                        )
                      ],
              ),
            ],
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            bloc: settingsBloc,
            builder: (BuildContext context, SettingsState settingsState) =>
                ExpansionTile(
              key: Key("optionColumns"),
              title: Text(L10N.of(context).tr.columns,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700)),
              children: <Widget>[
                SwitchListTile(
                  title: Text(L10N.of(context).tr.date),
                  value: settingsState.exportIncludeDate,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeDate: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.project),
                  value: settingsState.exportIncludeProject,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeProject: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.workType),
                  value: settingsState.exportIncludeWorkType,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeWorkType: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.description),
                  value: settingsState.exportIncludeDescription,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeDescription: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.combinedProjectDescription),
                  value: settingsState.exportIncludeProjectDescription,
                  onChanged: (bool value) => settingsBloc.add(SetBoolValueEvent(
                      exportIncludeProjectDescription: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.startTime),
                  value: settingsState.exportIncludeStartTime,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeStartTime: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.endTime),
                  value: settingsState.exportIncludeEndTime,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeEndTime: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
                SwitchListTile(
                  title: Text(L10N.of(context).tr.timeH),
                  value: settingsState.exportIncludeDurationHours,
                  onChanged: (bool value) => settingsBloc.add(
                      SetBoolValueEvent(exportIncludeDurationHours: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
              ],
            ),
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
                    child: Text("Select None"),
                    onPressed: () {
                      setState(() {
                        _exporterData.selectedProjects.clear();
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Select All"),
                    onPressed: () {
                      setState(() {
                        _exporterData.selectedProjects = <Project>[null]
                            .followedBy(projectsBloc.state.projects
                                .map((p) => Project.clone(p)))
                            .toList();
                      });
                    },
                  ),
                ],
              )
            ]
                .followedBy(<Project>[null]
                    .followedBy(projectsBloc.state.projects)
                    .map((project) => CheckboxListTile(
                          secondary: ProjectColour(
                            project: project,
                          ),
                          title: Text(
                              project?.name ?? L10N.of(context).tr.noProject),
                          value: _exporterData.selectedProjects
                              .any((p) => p?.id == project?.id),
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (_) => setState(() {
                            if (_exporterData.selectedProjects
                                .any((p) => p?.id == project?.id)) {
                              _exporterData.selectedProjects
                                  .removeWhere((p) => p?.id == project?.id);
                            } else {
                              _exporterData.selectedProjects.add(project);
                            }
                          }),
                        )))
                .toList(),
          ),
          ExpansionTile(
            title: Text(L10N.of(context).tr.workTypes,
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
                    child: Text("Select None"),
                    onPressed: () {
                      setState(() {
                        _exporterData.selectedWorkTypes.clear();
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Select All"),
                    onPressed: () {
                      setState(() {
                        _exporterData.selectedWorkTypes = <WorkType>[null]
                            .followedBy(workTypesBloc.state.workTypes
                                .map((p) => WorkType.clone(p)))
                            .toList();
                      });
                    },
                  ),
                ],
              )
            ]
                .followedBy(<WorkType>[null]
                    .followedBy(workTypesBloc.state.workTypes)
                    .map((workType) => CheckboxListTile(
                          secondary: WorkTypeBadge(
                            workType: workType,
                          ),
                          title: Text(
                              workType?.name ?? L10N.of(context).tr.noWorkType),
                          value: _exporterData.selectedWorkTypes
                              .any((p) => p?.id == workType?.id),
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (_) => setState(() {
                            if (_exporterData.selectedWorkTypes
                                .any((p) => p?.id == workType?.id)) {
                              _exporterData.selectedWorkTypes
                                  .removeWhere((p) => p?.id == workType?.id);
                            } else {
                              _exporterData.selectedWorkTypes.add(workType);
                            }
                          }),
                        )))
                .toList(),
          ),
          ExpansionTile(
            title: Text(L10N.of(context).tr.options,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w700)),
            children: <Widget>[
              BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settingsState) =>
                    SwitchListTile(
                  title: Text(L10N.of(context).tr.groupTimers),
                  value: settingsState.exportGroupTimers,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportGroupTimers: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settingsState) =>
                    SwitchListTile(
                  title: Text(
                      L10N.of(context).tr.includeDateRangeInExportFilename),
                  value: settingsState.exportIncludeDateRangeInFilename,
                  onChanged: (bool value) => settingsBloc.add(SetBoolValueEvent(
                      exportIncludeDateRangeInFilename: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settingsState) =>
                    SwitchListTile(
                  title: Text(L10N.of(context).tr.includeTimeInExportFilename),
                  value: settingsState.exportIncludeTimeInFilename,
                  onChanged: (bool value) => settingsBloc.add(
                      SetBoolValueEvent(exportIncludeTimeInFilename: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settingsState) =>
                    SwitchListTile(
                  title: Text(L10N.of(context).tr.timesheetExport),
                  value: settingsState.exportTimesheet,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportTimesheet: value)),
                  activeColor: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
        ].toList(),
      ),
      floatingActionButton: FloatingActionButton(
          key: Key("exportFAB"),
          child: Stack(
            // shenanigans to properly centre the icon (font awesome glyphs are variable
            // width but the library currently doesn't deal with that)
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 15,
                left: 19,
                child: Icon(FontAwesomeIcons.fileExport),
              )
            ],
          ),
          onPressed: () async {
            exporter.exportTimeEntries();
          }),
    );
  }
}
