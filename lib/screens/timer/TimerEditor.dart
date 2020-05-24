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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/work_types/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/components/WorkTypeBadge.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/clone_time.dart';

class TimerEditor extends StatefulWidget {
  final TimerEntry timer;
  TimerEditor({Key key, @required this.timer})
      : assert(timer != null),
        super(key: key);

  @override
  _TimerEditorState createState() => _TimerEditorState();
}

class _TimerEditorState extends State<TimerEditor> {
  TextEditingController _descriptionController;

  DateTime _startTime;
  DateTime _endTime;

  DateTime _oldStartTime;
  DateTime _oldEndTime;

  Project _project;
  WorkType _workType;
  FocusNode _descriptionFocus;
  final _formKey = GlobalKey<FormState>();
  Timer _updateTimer;
  StreamController<DateTime> _updateTimerStreamController;

  static DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy h:mma");

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.timer.description);
    _startTime = widget.timer.startTime;
    _endTime = widget.timer.endTime;
    _project = BlocProvider.of<ProjectsBloc>(context).getProjectByID(widget.timer.projectID);
    _workType = BlocProvider.of<WorkTypesBloc>(context).getWorkTypeByID(widget.timer.workTypeID);
    _descriptionFocus = FocusNode();
    _updateTimerStreamController = StreamController();
    _updateTimer = Timer.periodic(Duration(seconds: 1), (_) => _updateTimerStreamController.add(DateTime.now()));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionFocus.dispose();
    _updateTimer.cancel();
    _updateTimerStreamController.close();
    super.dispose();
  }

  void setStartTime(DateTime dt) {
    assert(dt != null);
    setState(() {
      // adjust the end time to keep a constant duration if we would somehow make the time negative
      if (_oldEndTime != null && dt.isAfter(_oldStartTime)) {
        Duration d = _oldEndTime.difference(_oldStartTime);
        _endTime = dt.add(d);
      }
      _startTime = dt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.editTimer),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (BuildContext context, ProjectsState projectsState) => Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: DropdownButton(
                        value: _project,
                        underline: Container(),
                        elevation: 0,
                        onChanged: (Project newProject) {
                          setState(() {
                            _project = newProject;
                          });
                        },
                        items: <DropdownMenuItem<Project>>[
                          DropdownMenuItem<Project>(
                            child: Row(
                              children: <Widget>[
                                ProjectColour(project: null),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Text(L10N.of(context).tr.noProject, style: TextStyle( color: Theme.of(context).disabledColor)),
                                ),
                              ],
                            ),
                            value: null,
                          )
                        ].followedBy(projectsState.projects.map(
                                (Project project) => DropdownMenuItem<Project>(
                                      child: Row(
                                        children: <Widget>[
                                          ProjectColour( project: project,),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                            child: Text(project.name),
                                          ),
                                        ],
                                      ),
                                      value: project,
                                    )
                               )).toList(),
                      )
                  ),
            ),
            BlocBuilder<WorkTypesBloc, WorkTypesState>(
              builder: (BuildContext context, WorkTypesState workTypesState) =>
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: DropdownButton(
                        value: _workType,
                        underline: Container(),
                        elevation: 0,
                        onChanged: (WorkType newWorkType) {
                          setState(() {
                            _workType = newWorkType;
                          });
                        },
                        items: <DropdownMenuItem<WorkType>>[
                          DropdownMenuItem<WorkType>(
                            child: Row(
                              children: <Widget>[
                                WorkTypeBadge(workType: null),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Text(L10N.of(context).tr.noWorkType,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor)),
                                ),
                              ],
                            ),
                            value: null,
                          )
                        ]
                            .followedBy(workTypesState.workTypes.map(
                                (WorkType workType) =>
                                    DropdownMenuItem<WorkType>(
                                      child: Row(
                                        children: <Widget>[
                                          WorkTypeBadge(
                                            workType: workType,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8.0, 0, 0, 0),
                                            child: Text(workType.name),
                                          ),
                                        ],
                                      ),
                                      value: workType,
                                    )))
                            .toList(),
                      )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child:
                settingsBloc.state.autocompleteDescription
                  ? TypeAheadField<String>(
                      direction: AxisDirection.down,
                      textFieldConfiguration: TextFieldConfiguration<String>(
                        controller: _descriptionController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: L10N.of(context).tr.description,
                          hintText: L10N.of(context).tr.whatWereYouDoing,
                        ),
                      ),
                      itemBuilder: (BuildContext context, String desc) =>
                          ListTile(
                             title: Text(desc)
                          ),
                      onSuggestionSelected: (String description) => _descriptionController.text = description,
                      suggestionsCallback: (pattern) async {
                        if (pattern.length < 2) return [];

                        List<String> descriptions = timers.state.timers
                            .where((timer) => timer.description != null)
                            .where((timer) => timer.description.toLowerCase().contains(pattern.toLowerCase()) ?? false)
                            .map((timer) => timer.description)
                            .toSet()
                            .toList();
                        return descriptions;
                      },
                    )
                  : TextFormField(
                      controller: _descriptionController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: L10N.of(context).tr.description,
                        hintText: L10N.of(context).tr.whatWereYouDoing,
                      ),
                    ),
            ),
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: ListTile(
                title: Text(L10N.of(context).tr.startTime),
                trailing: Text(_dateFormat.format(_startTime)),
                onTap: () async {
                  _oldStartTime = _startTime.clone();
                  _oldEndTime = _endTime.clone();
                  DateTime newStartTime = await DatePicker.showDateTimePicker(
                          context,
                          currentTime: _startTime,
                          maxTime: _endTime == null ? DateTime.now() : null,
                          onChanged: (DateTime dt) => setStartTime(dt),
                          onConfirm: (DateTime dt) => setStartTime(dt),
                          theme: DatePickerTheme(
                            cancelStyle: Theme.of(context).textTheme.button,
                            doneStyle: Theme.of(context).textTheme.button,
                            itemStyle: Theme.of(context).textTheme.body1,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          )
                        );

                  // if the user cancelled, this should be null
                  if (newStartTime == null) {
                    setState(() {
                      _startTime = _oldStartTime;
                      _endTime = _oldEndTime;
                    });
                  }
                },
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  color: Theme.of(context).accentColor,
                  foregroundColor: Theme.of(context).accentIconTheme.color,
                  icon: FontAwesomeIcons.clock,
                  onTap: () {
                    _oldStartTime = _startTime;
                    _oldEndTime = _endTime;
                    setStartTime(DateTime.now());
                  },
                ),
              ],
            ),
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: ListTile(
                title: Text(L10N.of(context).tr.endTime),
                trailing: Text(_endTime == null ? "—" : _dateFormat.format(_endTime)),
                onTap: () async {
                  _oldEndTime = _endTime.clone();
                  DateTime newEndTime = await DatePicker.showDateTimePicker(
                      context,
                      currentTime: _endTime,
                      minTime: _startTime,
                      onChanged: (DateTime dt) => setState(() => _endTime = dt),
                      onConfirm: (DateTime dt) => setState(() => _endTime = dt),
                      theme: DatePickerTheme(
                        cancelStyle: Theme.of(context).textTheme.button,
                        doneStyle: Theme.of(context).textTheme.button,
                        itemStyle: Theme.of(context).textTheme.body1,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      )
                    );

                  // if the user cancelled, this should be null
                  if (newEndTime == null) {
                    setState(() {
                      _endTime = _oldEndTime;
                    });
                  }
                },
              ),
              secondaryActions:
                  _endTime == null
                  ? <Widget>[
                      IconSlideAction(
                        color: Theme.of(context).accentColor,
                        foregroundColor: Theme.of(context).accentIconTheme.color,
                        icon: FontAwesomeIcons.clock,
                        onTap: () => setState(() => _endTime = DateTime.now()),
                      ),
                    ]
                  : <Widget>[
                      IconSlideAction(
                        color: Theme.of(context).accentColor,
                        foregroundColor: Theme.of(context).accentIconTheme.color,
                        icon: FontAwesomeIcons.clock,
                        onTap: () => setState(() => _endTime = DateTime.now()),
                      ),
                      IconSlideAction(
                        color: Theme.of(context).errorColor,
                        foregroundColor: Theme.of(context).accentIconTheme.color,
                        icon: FontAwesomeIcons.minusCircle,
                        onTap: () {
                          setState(() {
                            _endTime = null;
                          });
                        },
                      )
                    ],
            ),
            StreamBuilder(
              initialData: DateTime.now(),
              stream: _updateTimerStreamController.stream,
              builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) => ListTile(
                title: Text(L10N.of(context).tr.duration),
                trailing: Text(TimerEntry.formatDuration(
                    _endTime == null
                    ? snapshot.data.difference(_startTime)
                    : _endTime.difference(_startTime)
                  )),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("saveDetails"),
        child: Stack(
          // shenanigans to properly centre the icon (font awesome glyphs are variable
          // width but the library currently doesn't deal with that)
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 14,
              left: 16,
              child: Icon(FontAwesomeIcons.solidSave),
            )
          ],
        ),
        onPressed: () async {
          bool valid = _formKey.currentState.validate();
          if (!valid) return;

          TimerEntry timer = TimerEntry(
            id: widget.timer.id,
            startTime: _startTime,
            endTime: _endTime,
            projectID: _project?.id,
            workTypeID: _workType?.id,
            description: _descriptionController.text.trim(),
          );

          assert(timers != null);
          timers.add(EditTimer(timer));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}