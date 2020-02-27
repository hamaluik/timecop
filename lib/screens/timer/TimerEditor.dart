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
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
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
    Widget endTimePicker;
    if(_endTime == null) {
      endTimePicker = Container();
    }
    else {
      endTimePicker = DateTimeFormField(
        initialValue: _endTime,
        firstDate: _startTime,
        label: "End Time",
        autovalidate: true,
        validator: (DateTime dt) {
          if(dt != null && dt.isBefore(_startTime)) {
            return "End time must be after start time!";
          }
          return null;
        },
        onSaved: (DateTime dt) => _endTime = dt,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Timer"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (BuildContext context, ProjectsState projectsState) => DropdownButton(
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
                            child: Text("(no project)", style: TextStyle(color: Theme.of(context).disabledColor)),
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
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "What were you doing?",
                ),
              ),
              DateTimeFormField(
                initialValue: _startTime,
                label: "Start Time",
                autovalidate: true,
                validator: (DateTime dateTime) {
                  if (dateTime == null) {
                    return "Please choose a start time";
                  }
                  return null;
                },
                onSaved: (DateTime dt) => setState(() => _startTime = dt),
              ),
              endTimePicker,
              StreamBuilder(
                initialData: DateTime.now(),
                stream: _updateTimerStreamController.stream,
                builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) => ListTile(
                  title: Text("Timer Duration"),
                  trailing: Text(TimerEntry.formatDuration(
                    _endTime == null
                      ? snapshot.data.difference(_startTime)
                      : _endTime.difference(_startTime)
                  )),
                ),
              ),
              SwitchListTile(
                title: Text("Timer is stopped"),
                value: _endTime != null,
                activeColor: Theme.of(context).accentColor,
                onChanged: (ended) {
                  setState(() {
                    _endTime = ended ? DateTime.now() : null;
                  });
                },
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text("Save"),
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
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}