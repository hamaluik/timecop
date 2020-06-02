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
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_share/flutter_share.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/project_description_pair.dart';
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
  DateTime _startDate;
  DateTime _endDate;
  List<Project> selectedProjects = [];
  static final DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy");
  static final DateFormat _exportDateFormat = DateFormat.yMd();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    assert(projects != null);
    selectedProjects = <Project>[null]
        .followedBy(projects.state.projects.map((p) => Project.clone(p)))
        .toList();

    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _startDate = settingsBloc.getFilterStartDate();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    // TODO: break this into components or something so we don't have such a massively unmanagement build function

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(L10N.of(context).tr.export),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.database),
            onPressed: () async {
              var databasesPath = await getDatabasesPath();
              var dbPath = p.join(databasesPath, 'timecop.db');

              try {
                // on android, copy it somewhere where it can be shared
                if (Platform.isAndroid) {
                  Directory directory = await getExternalStorageDirectory();
                  File copiedDB = await File(dbPath)
                      .copy(p.join(directory.path, "timecop.db"));
                  dbPath = copiedDB.path;
                }
                await FlutterShare.shareFile(
                    title: L10N
                        .of(context)
                        .tr
                        .timeCopDatabase(_dateFormat.format(DateTime.now())),
                    filePath: dbPath);
              } on Exception catch (e) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(
                    e.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(seconds: 5),
                ));
              }
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
                    child: Text(_startDate == null
                        ? "—"
                        : _dateFormat.format(_startDate)),
                  ),
                  onTap: () async {
                    await DatePicker.showDatePicker(context,
                        currentTime: _startDate,
                        onChanged: (DateTime dt) => setState(() =>
                            _startDate = DateTime(dt.year, dt.month, dt.day)),
                        onConfirm: (DateTime dt) => setState(() =>
                            _startDate = DateTime(dt.year, dt.month, dt.day)),
                        theme: DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.button,
                          doneStyle: Theme.of(context).textTheme.button,
                          itemStyle: Theme.of(context).textTheme.bodyText2,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ));
                  },
                ),
                secondaryActions: _startDate == null
                    ? <Widget>[]
                    : <Widget>[
                        IconSlideAction(
                          color: Theme.of(context).errorColor,
                          foregroundColor:
                              Theme.of(context).accentIconTheme.color,
                          icon: FontAwesomeIcons.minusCircle,
                          onTap: () {
                            setState(() {
                              _startDate = null;
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
                    child: Text(
                        _endDate == null ? "—" : _dateFormat.format(_endDate)),
                  ),
                  onTap: () async {
                    await DatePicker.showDatePicker(context,
                        currentTime: _endDate,
                        onChanged: (DateTime dt) => setState(() => _endDate =
                            DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                        onConfirm: (DateTime dt) => setState(() => _endDate =
                            DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                        theme: DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.button,
                          doneStyle: Theme.of(context).textTheme.button,
                          itemStyle: Theme.of(context).textTheme.bodyText2,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ));
                  },
                ),
                secondaryActions: _endDate == null
                    ? <Widget>[]
                    : <Widget>[
                        IconSlideAction(
                          color: Theme.of(context).errorColor,
                          foregroundColor:
                              Theme.of(context).accentIconTheme.color,
                          icon: FontAwesomeIcons.minusCircle,
                          onTap: () {
                            setState(() {
                              _endDate = null;
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
                    child: Text(L10N.of(context).tr.selectNone),
                    onPressed: () {
                      setState(() {
                        selectedProjects.clear();
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text(L10N.of(context).tr.selectAll),
                    onPressed: () {
                      setState(() {
                        selectedProjects = <Project>[null]
                            .followedBy(projectsBloc.state.projects
                                .map((p) => Project.clone(p)))
                            .toList();
                      });
                    },
                  ),
                ],
              )
            ]
                .followedBy(<Project>[
                  null
                ].followedBy(projectsBloc.state.projects).map((project) =>
                    CheckboxListTile(
                      secondary: ProjectColour(
                        project: project,
                      ),
                      title:
                          Text(project?.name ?? L10N.of(context).tr.noProject),
                      value: selectedProjects.any((p) => p?.id == project?.id),
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (_) => setState(() {
                        if (selectedProjects.any((p) => p?.id == project?.id)) {
                          selectedProjects
                              .removeWhere((p) => p?.id == project?.id);
                        } else {
                          selectedProjects.add(project);
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
            final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
            assert(timers != null);
            final ProjectsBloc projects =
                BlocProvider.of<ProjectsBloc>(context);
            assert(projects != null);

            List<String> headers = [];
            if (settingsBloc.state.exportIncludeDate) {
              headers.add(L10N.of(context).tr.date);
            }
            if (settingsBloc.state.exportIncludeProject) {
              headers.add(L10N.of(context).tr.project);
            }
            if (settingsBloc.state.exportIncludeDescription) {
              headers.add(L10N.of(context).tr.description);
            }
            if (settingsBloc.state.exportIncludeProjectDescription) {
              headers.add(L10N.of(context).tr.combinedProjectDescription);
            }
            if (settingsBloc.state.exportIncludeStartTime) {
              headers.add(L10N.of(context).tr.startTime);
            }
            if (settingsBloc.state.exportIncludeEndTime) {
              headers.add(L10N.of(context).tr.endTime);
            }
            if (settingsBloc.state.exportIncludeDurationHours) {
              headers.add(L10N.of(context).tr.timeH);
            }

            List<TimerEntry> filteredTimers = timers.state.timers
                .where((t) => t.endTime != null)
                .where((t) => selectedProjects.any((p) => p?.id == t.projectID))
                .where((t) =>
                    _startDate == null ? true : t.startTime.isAfter(_startDate))
                .where((t) =>
                    _endDate == null ? true : t.endTime.isBefore(_endDate))
                .toList();
            filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));

            // group similar timers if that's what you're in to
            if (settingsBloc.state.exportGroupTimers &&
                !(settingsBloc.state.exportIncludeStartTime ||
                    settingsBloc.state.exportIncludeEndTime)) {
              filteredTimers = timers.state.timers
                  .where((t) => t.endTime != null)
                  .where(
                      (t) => selectedProjects.any((p) => p?.id == t.projectID))
                  .where((t) => _startDate == null
                      ? true
                      : t.startTime.isAfter(_startDate))
                  .where((t) =>
                      _endDate == null ? true : t.endTime.isBefore(_endDate))
                  .toList();
              filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));

              // now start grouping those suckers
              LinkedHashMap<String,
                      LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>>
                  derp = LinkedHashMap();
              for (TimerEntry timer in filteredTimers) {
                String date = _exportDateFormat.format(timer.startTime);
                LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>
                    pairedEntries =
                    derp.putIfAbsent(date, () => LinkedHashMap());
                List<TimerEntry> pairedList = pairedEntries.putIfAbsent(
                    ProjectDescriptionPair(timer.projectID, timer.description),
                    () => <TimerEntry>[]);
                pairedList.add(timer);
              }

              // ok, now they're grouped based on date, then combined project + description pairs
              // time to get them back into a flat list
              filteredTimers = derp.values.expand(
                  (LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>
                      pairedEntries) {
                return pairedEntries.values
                    .map((List<TimerEntry> groupedEntries) {
                  assert(groupedEntries.isNotEmpty);

                  // not a grouped entry
                  if (groupedEntries.length == 1) return groupedEntries[0];

                  // yes a group entry, build a dummy timer entry
                  Duration totalTime = groupedEntries.fold(
                      Duration(),
                      (Duration d, TimerEntry t) =>
                          d + t.endTime.difference(t.startTime));
                  return TimerEntry.clone(groupedEntries[0],
                      endTime: groupedEntries[0].startTime.add(totalTime));
                });
              }).toList();
            }

            List<List<String>> data =
                <List<String>>[headers].followedBy(filteredTimers.map((timer) {
              List<String> row = [];
              if (settingsBloc.state.exportIncludeDate) {
                row.add(_exportDateFormat.format(timer.startTime));
              }
              if (settingsBloc.state.exportIncludeProject) {
                row.add(projects.getProjectByID(timer.projectID)?.name ?? "");
              }
              if (settingsBloc.state.exportIncludeDescription) {
                row.add(timer.description ?? "");
              }
              if (settingsBloc.state.exportIncludeProjectDescription) {
                row.add((projects.getProjectByID(timer.projectID)?.name ?? "") +
                    ": " +
                    (timer.description ?? ""));
              }
              if (settingsBloc.state.exportIncludeStartTime) {
                row.add(timer.startTime.toUtc().toIso8601String());
              }
              if (settingsBloc.state.exportIncludeEndTime) {
                row.add(timer.endTime.toUtc().toIso8601String());
              }
              if (settingsBloc.state.exportIncludeDurationHours) {
                row.add((timer.endTime
                            .difference(timer.startTime)
                            .inSeconds
                            .toDouble() /
                        3600.0)
                    .toStringAsFixed(4));
              }
              return row;
            })).toList();
            String csv = ListToCsvConverter().convert(data);
            print('CSV:');
            print(csv);

            Directory directory;
            if (Platform.isAndroid) {
              directory = await getExternalStorageDirectory();
            } else {
              directory = await getApplicationDocumentsDirectory();
            }
            final String localPath = '${directory.path}/timecop.csv';
            File file = File(localPath);
            await file.writeAsString(csv, flush: true);
            await FlutterShare.shareFile(
                title: L10N
                    .of(context)
                    .tr
                    .timeCopEntries(_dateFormat.format(DateTime.now())),
                filePath: localPath);
          }),
    );
  }
}
