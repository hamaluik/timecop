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
import 'package:timecop/blocs/projects/projects_state.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';

class ExportScreen extends StatefulWidget {
  ExportScreen({Key key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime _startDate;
  DateTime _endDate;
  List<Project> selectedProjects = [];
  static DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy");

  @override
  void initState() {
    super.initState();
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    assert(projects != null);
    selectedProjects = <Project>[null].followedBy(projects.state.projects.map((p) => Project.clone(p))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.export),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.database),
            onPressed: () async {
              var databasesPath = await getDatabasesPath();
              var dbPath = p.join(databasesPath, 'timecop.db');

              // on android, copy it somewhere where it can be shared
              if (Platform.isAndroid) {
                Directory directory = await getExternalStorageDirectory();
                File copiedDB = await File(dbPath).copy(p.join(directory.path, "timecop.db"));
                dbPath = copiedDB.path;
              }
              await FlutterShare.shareFile(title: L10N.of(context).tr.timeCopDatabase(_dateFormat.format(DateTime.now())), filePath: dbPath);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  L10N.of(context).tr.filter,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w800
                  )
                ),
              ],
            ),
          ),
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.15,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.calendar),
              title: Text(L10N.of(context).tr.from),
              trailing: Text(_startDate == null ? "—" : _dateFormat.format(_startDate)),
              onTap: () async {
                await DatePicker.showDatePicker(
                  context,
                  currentTime: _startDate,
                  onChanged: (DateTime dt) => setState(() => _startDate = dt),
                  onConfirm: (DateTime dt) => setState(() => _startDate = dt),
                  theme: DatePickerTheme(
                    cancelStyle: Theme.of(context).textTheme.button,
                    doneStyle: Theme.of(context).textTheme.button,
                    itemStyle: Theme.of(context).textTheme.body1,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                );
              },
            ),
            secondaryActions:
              _startDate == null
                ? <Widget>[]
                : <Widget>[
                  IconSlideAction(
                    color: Theme.of(context).errorColor,
                    foregroundColor: Theme.of(context).accentIconTheme.color,
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
              trailing: Text(_endDate == null ? "—" : _dateFormat.format(_endDate)),
              onTap: () async {
                await DatePicker.showDatePicker(
                  context,
                  currentTime: _endDate,
                  onChanged: (DateTime dt) => setState(() => _endDate = dt),
                  onConfirm: (DateTime dt) => setState(() => _endDate = dt),
                  theme: DatePickerTheme(
                    cancelStyle: Theme.of(context).textTheme.button,
                    doneStyle: Theme.of(context).textTheme.button,
                    itemStyle: Theme.of(context).textTheme.body1,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                );
              },
            ),
            secondaryActions:
              _endDate == null
                ? <Widget>[]
                : <Widget>[
                  IconSlideAction(
                    color: Theme.of(context).errorColor,
                    foregroundColor: Theme.of(context).accentIconTheme.color,
                    icon: FontAwesomeIcons.minusCircle,
                    onTap: () {
                      setState(() {
                        _endDate = null;
                      });
                    },
                  )
                ],
          ),
          BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (BuildContext context, ProjectsState state) {
              return Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        L10N.of(context).tr.includeProjects,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: Theme.of(context).textTheme.body1.fontSize,
                          fontWeight: FontWeight.w800
                        )
                      ),
                      trailing: Checkbox(
                        tristate: true,
                        value: selectedProjects.length == 1
                          ? false
                          : (selectedProjects.length == state.projects.length + 1
                            ? true
                            : null),
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (_) => setState(() {
                          if(selectedProjects.length == state.projects.length + 1) {
                            selectedProjects.clear();
                          }
                          else {
                            selectedProjects = <Project>[null].followedBy(state.projects.map((p) => Project.clone(p))).toList();
                          }
                        }),
                      ),
                      onTap: () => setState(() {
                        if(selectedProjects.length == state.projects.length + 1) {
                          selectedProjects.clear();
                        }
                        else {
                          selectedProjects = <Project>[null].followedBy(state.projects.map((p) => Project.clone(p))).toList();
                        }
                      })
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: <Project>[null].followedBy(state.projects).map((project) => ListTile(
                          leading: ProjectColour(project: project,),
                          title: Text(project?.name ?? L10N.of(context).tr.noProject),
                          trailing: Checkbox(
                            value: selectedProjects.any((p) => p?.id == project?.id),
                            activeColor: Theme.of(context).accentColor,
                            onChanged: (_) => setState(() {
                              if(selectedProjects.any((p) => p?.id == project?.id)) {
                                selectedProjects.removeWhere((p) => p?.id == project?.id);
                              }
                              else {
                                selectedProjects.add(project);
                              }
                            }),
                          ),
                          onTap: () => setState(() {
                            if(selectedProjects.any((p) => p?.id == project?.id)) {
                              selectedProjects.removeWhere((p) => p?.id == project?.id);
                            }
                            else {
                              selectedProjects.add(project);
                            }
                          }),
                        )).toList(),
                      )
                    )
                  ],
                )
              );
            }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.fileExport),
        onPressed: () async {
          final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
          assert(timers != null);
          final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
          assert(projects != null);

          List<List<String>> data = <List<String>>[
            <String>[L10N.of(context).tr.project, L10N.of(context).tr.description, L10N.of(context).tr.timeH],
          ]
          .followedBy(
            timers.state.timers
              .where((t) => t.endTime != null)
              .where((t) => selectedProjects.any((p) => p?.id == t.projectID))
              .map(
                (timer) => <String>[
                  projects.getProjectByID(timer.projectID)?.name ?? "",
                  timer.description ?? "",
                  (timer.endTime.difference(timer.startTime).inSeconds.toDouble() / 3600.0).toStringAsFixed(4),
                ]
              )
          ).toList();
          String csv = ListToCsvConverter().convert(data);

          Directory directory;
          if (Platform.isAndroid) {
            directory = await getExternalStorageDirectory();
          }
          else {
            directory = await getApplicationDocumentsDirectory();
          }
          final String localPath = '${directory.path}/timecop.csv';
          File file = File(localPath);
          await file.writeAsString(csv, flush: true);
          await FlutterShare.shareFile(title: L10N.of(context).tr.timeCopEntries(_dateFormat.format(DateTime.now())), filePath: localPath);
        }
        ),
    );
  }
}