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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

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
  Project _project;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.editTimer),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                            child: Text(L10N.of(context).tr.noProject, style: TextStyle(color: Theme.of(context).disabledColor)),
                          ),
                        ],
                      ),
                      value: null,
                    )
                  ].followedBy(projectsState.projects.map(
                    (Project project) => DropdownMenuItem<Project>(
                      child: Row(
                        children: <Widget>[
                          ProjectColour(project: project,),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
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
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: L10N.of(context).tr.description,
                  hintText: L10N.of(context).tr.whatWereYouDoing,
                ),
              ),
            ),
            ListTile(
              title: Text(L10N.of(context).tr.startTime),
              trailing: Text(_dateFormat.format(_startTime)),
              onTap: () async {
                await DatePicker.showDateTimePicker(
                  context,
                  currentTime: _startTime,
                  onChanged: (DateTime dt) => setState(() => _startTime = dt),
                  theme: DatePickerTheme(
                    cancelStyle: Theme.of(context).textTheme.button,
                    doneStyle: Theme.of(context).textTheme.button,
                    itemStyle: Theme.of(context).textTheme.body1,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                );
              },
            ),
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: ListTile(
                title: Text(L10N.of(context).tr.endTime),
                trailing: Text(_endTime == null ? "—" : _dateFormat.format(_endTime)),
                onTap: () async {
                  await DatePicker.showDateTimePicker(
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
                },
              ),
              secondaryActions:
                _endTime == null
                  ? <Widget>[]
                  : <Widget>[
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
        child: Icon(FontAwesomeIcons.solidSave),
        onPressed: () async {
          bool valid = _formKey.currentState.validate();
          if(!valid) return;

          TimerEntry timer = TimerEntry(
            id: widget.timer.id,
            startTime: _startTime,
            endTime: _endTime,
            projectID: _project?.id,
            description: _descriptionController.text.trim(),
          );

          final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
          assert(timers != null);
          timers.add(EditTimer(timer));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}