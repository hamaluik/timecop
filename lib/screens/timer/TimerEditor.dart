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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/clone_time.dart';
import 'package:timecop/themes.dart';

enum _DateTimeMenuItems { now }

class TimerEditor extends StatefulWidget {
  final TimerEntry timer;
  const TimerEditor({Key? key, required this.timer}) : super(key: key);

  @override
  State<TimerEditor> createState() => _TimerEditorState();
}

class _TimerEditorState extends State<TimerEditor> {
  TextEditingController? _descriptionController;
  TextEditingController? _notesController;
  String? _notes;

  late DateTime _startTime;
  DateTime? _endTime;

  DateTime? _oldStartTime;
  DateTime? _oldEndTime;

  Project? _project;
  late FocusNode _descriptionFocus;
  final _formKey = GlobalKey<FormState>();
  late Timer _updateTimer;
  late StreamController<DateTime> _updateTimerStreamController;

  late ProjectsBloc _projectsBloc;

  @override
  void initState() {
    super.initState();
    _projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    _notes = widget.timer.notes ?? "";
    _descriptionController =
        TextEditingController(text: widget.timer.description);
    _notesController = TextEditingController(text: _notes);
    _startTime = widget.timer.startTime;
    _endTime = widget.timer.endTime;
    _project = BlocProvider.of<ProjectsBloc>(context)
        .getProjectByID(widget.timer.projectID);
    _descriptionFocus = FocusNode();
    _updateTimerStreamController = StreamController();
    _updateTimer = Timer.periodic(const Duration(seconds: 1),
        (_) => _updateTimerStreamController.add(DateTime.now()));
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    _descriptionFocus.dispose();
    _updateTimer.cancel();
    _updateTimerStreamController.close();
    super.dispose();
  }

  void setStartTime(DateTime dt) {
    setState(() {
      // adjust the end time to keep a constant duration if we would somehow make the time negative
      if (_oldEndTime != null && dt.isAfter(_oldStartTime!)) {
        Duration d = _oldEndTime!.difference(_oldStartTime!);
        _endTime = dt.add(d);
      }
      _startTime = dt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final timers = BlocProvider.of<TimersBloc>(context);
    final dateFormat = DateFormat.yMMMEd().add_jm();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.editTimer),
        actions: [
          IconButton(
              tooltip: L10N.of(context).tr.delete,
              onPressed: () async {
                final timersBloc = BlocProvider.of<TimersBloc>(context);
                final bool delete = await (showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(L10N.of(context).tr.confirmDelete),
                              content:
                                  Text(L10N.of(context).tr.deleteTimerConfirm),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(L10N.of(context).tr.cancel),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text(L10N.of(context).tr.delete),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            ))) ??
                    false;
                if (delete) {
                  timersBloc.add(DeleteTimer(widget.timer));
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(FontAwesomeIcons.trash))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (BuildContext context, ProjectsState projectsState) =>
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: DropdownButton(
                        value: (_project?.archived ?? true) ? null : _project,
                        underline: const SizedBox(),
                        onChanged: (Project? newProject) {
                          setState(() {
                            _project = newProject;
                          });
                        },
                        items: <DropdownMenuItem<Project>>[
                          DropdownMenuItem<Project>(
                            value: null,
                            child: Row(
                              children: <Widget>[
                                const ProjectColour(project: null),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Text(L10N.of(context).tr.noProject,
                                      style: TextStyle(
                                          color:
                                              ThemeUtil.getOnBackgroundLighter(
                                                  context))),
                                ),
                              ],
                            ),
                          )
                        ]
                            .followedBy(projectsState.projects
                                .where((p) => !p.archived)
                                .map((Project project) =>
                                    DropdownMenuItem<Project>(
                                      value: project,
                                      child: Row(
                                        children: <Widget>[
                                          ProjectColour(
                                            project: project,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 0, 0, 0),
                                            child: Text(project.name),
                                          ),
                                        ],
                                      ),
                                    )))
                            .toList(),
                      )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: settingsBloc.state.autocompleteDescription
                  ? TypeAheadField<String?>(
                      direction: AxisDirection.down,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _descriptionController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: L10N.of(context).tr.description,
                          hintText: L10N.of(context).tr.whatWereYouDoing,
                        ),
                      ),
                      noItemsFoundBuilder: (context) => ListTile(
                          title: Text(L10N.of(context).tr.noItemsFound),
                          enabled: false),
                      itemBuilder: (BuildContext context, String? desc) =>
                          ListTile(title: Text(desc!)),
                      onSuggestionSelected: (String? description) =>
                          _descriptionController!.text = description!,
                      suggestionsCallback: (pattern) async {
                        if (pattern.length < 2) return [];

                        List<String?> descriptions = timers.state.timers
                            .where((timer) => timer.description != null)
                            .where((timer) => !(_projectsBloc
                                    .getProjectByID(timer.projectID)
                                    ?.archived ==
                                true))
                            .where((timer) =>
                                timer.description
                                    ?.toLowerCase()
                                    .contains(pattern.toLowerCase()) ??
                                false)
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
            ListTile(
              title: Row(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  child: Text(L10N.of(context).tr.startTime),
                ),
                Expanded(
                    flex: 3,
                    child: Text(
                      dateFormat.format(_startTime),
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyMedium,
                    )),
                PopupMenuButton<_DateTimeMenuItems>(
                    onSelected: (menuItem) {
                      switch (menuItem) {
                        case _DateTimeMenuItems.now:
                          _oldStartTime = _startTime;
                          _oldEndTime = _endTime;
                          setStartTime(DateTime.now());
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                          PopupMenuItem(
                            value: _DateTimeMenuItems.now,
                            child: Text(L10N.of(context).tr.setToCurrentTime),
                          )
                        ]),
              ]),
              onTap: () async {
                _oldStartTime = _startTime.clone();
                _oldEndTime = _endTime?.clone();
                DateTime? newStartTime =
                    await dt.DatePicker.showDateTimePicker(context,
                        currentTime: _startTime,
                        maxTime: _endTime == null ? DateTime.now() : null,
                        onChanged: (DateTime dt) => setStartTime(dt),
                        onConfirm: (DateTime dt) => setStartTime(dt),
                        theme: dt.DatePickerTheme(
                          cancelStyle: theme.textTheme.labelLarge!,
                          doneStyle: theme.textTheme.labelLarge!,
                          itemStyle: theme.textTheme.bodyMedium!,
                          backgroundColor: theme.colorScheme.surface,
                        ));

                // if the user cancelled, this should be null
                if (newStartTime == null) {
                  setState(() {
                    _startTime = _oldStartTime!;
                    _endTime = _oldEndTime;
                  });
                }
              },
            ),
            ListTile(
              title: Row(children: [
                Expanded(child: Text(L10N.of(context).tr.endTime)),
                Expanded(
                    flex: 3,
                    child: Text(
                      _endTime == null ? "--" : dateFormat.format(_endTime!),
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyMedium,
                    )),
                if (_endTime != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    tooltip: L10N.of(context).tr.remove,
                    icon: const Icon(FontAwesomeIcons.circleMinus),
                    onPressed: () {
                      setState(() {
                        _endTime = null;
                      });
                    },
                  ),
                PopupMenuButton<_DateTimeMenuItems>(
                    onSelected: (menuItem) {
                      switch (menuItem) {
                        case _DateTimeMenuItems.now:
                          setState(() => _endTime = DateTime.now());
                      }
                    },
                    itemBuilder: (_) => [
                          PopupMenuItem(
                            value: _DateTimeMenuItems.now,
                            child: Text(L10N.of(context).tr.setToCurrentTime),
                          )
                        ])
              ]),
              onTap: () async {
                _oldEndTime = _endTime?.clone();
                DateTime? newEndTime = await dt.DatePicker.showDateTimePicker(
                    context,
                    currentTime: _endTime,
                    minTime: _startTime,
                    onChanged: (DateTime dt) => setState(() => _endTime = dt),
                    onConfirm: (DateTime dt) => setState(() => _endTime = dt),
                    theme: dt.DatePickerTheme(
                      cancelStyle: theme.textTheme.labelLarge!,
                      doneStyle: theme.textTheme.labelLarge!,
                      itemStyle: theme.textTheme.bodyMedium!,
                      backgroundColor: theme.colorScheme.surface,
                    ));

                // if the user cancelled, this should be null
                if (newEndTime == null) {
                  setState(() {
                    _endTime = _oldEndTime;
                  });
                }
              },
            ),
            StreamBuilder(
              initialData: DateTime.now(),
              stream: _updateTimerStreamController.stream,
              builder:
                  (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
                final duration = _endTime == null
                    ? snapshot.data!.difference(_startTime)
                    : _endTime!.difference(_startTime);
                return ListTile(
                  title: Text(L10N.of(context).tr.duration),
                  trailing: Text(
                    TimerEntry.formatDuration(duration),
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontFeatures: [const FontFeature.tabularFigures()]),
                  ),
                  onTap: _endTime != null
                      ? () async {
                          _oldEndTime = _endTime!.clone();
                          DateTime? newEndTime = await dt.DatePicker.showPicker(
                              context,
                              pickerModel: _DurationPickerModel(
                                  startDateTime: _startTime,
                                  endTime: _endTime!),
                              onChanged: (DateTime dt) =>
                                  setState(() => _endTime = dt),
                              onConfirm: (DateTime dt) =>
                                  setState(() => _endTime = dt),
                              theme: dt.DatePickerTheme(
                                cancelStyle: theme.textTheme.labelLarge!,
                                doneStyle: theme.textTheme.labelLarge!,
                                itemStyle: theme.textTheme.bodyMedium!,
                                backgroundColor: theme.colorScheme.surface,
                              ));

                          // if the user cancelled, this should be null
                          if (newEndTime == null) {
                            setState(() {
                              _endTime = _oldEndTime;
                            });
                          }
                        }
                      : null,
                );
              },
            ),
            ListTile(
              title: Text(L10N.of(context).tr.notes),
              onTap: () async => await _editNotes(context),
            ),
            Expanded(
                child: InkWell(
                    onTap: () async => await _editNotes(context),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Markdown(data: _notes!)))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("saveDetails"),
        tooltip: L10N.of(context).tr.save,
        child: const Stack(
          // shenanigans to properly centre the icon (font awesome glyphs are variable
          // width but the library currently doesn't deal with that)
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 14,
              left: 16,
              child: Icon(FontAwesomeIcons.check),
            )
          ],
        ),
        onPressed: () async {
          bool valid = _formKey.currentState!.validate();
          if (!valid) return;

          TimerEntry timer = TimerEntry(
            id: widget.timer.id,
            startTime: _startTime,
            endTime: _endTime,
            projectID: _project?.id,
            description: _descriptionController!.text.trim(),
            notes: _notes!.isEmpty ? null : _notes,
          );

          timers.add(EditTimer(timer));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _editNotes(BuildContext context) async {
    _notesController!.text = _notes!;
    String? n = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(L10N.of(context).tr.notes),
            content: TextFormField(
              controller: _notesController,
              autofocus: true,
              autocorrect: true,
              maxLines: null,
              expands: true,
              smartDashesType: SmartDashesType.enabled,
              smartQuotesType: SmartQuotesType.enabled,
              onSaved: (String? n) => Navigator.of(context).pop(n),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(L10N.of(context).tr.cancel),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () =>
                      Navigator.of(context).pop(_notesController!.text),
                  child: Text(
                    L10N.of(context).tr.save,
                  ))
            ],
          );
        });
    if (n != null) {
      setState(() {
        _notes = n.trim();
      });
    }
  }
}

class _DurationPickerModel extends dt.BasePickerModel {
  final DateTime _startDateTime;
  late final int _maxHours;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  _DurationPickerModel(
      {required DateTime startDateTime, required DateTime endTime})
      : _startDateTime = startDateTime {
    final duration = endTime.difference(startDateTime);
    _hours = duration.inHours;
    _minutes = duration.inMinutes % 60;
    _seconds = duration.inSeconds % 60;
    _maxHours = max(_hours + 5, 24);
  }

  @override
  int currentLeftIndex() => _hours;

  @override
  int currentMiddleIndex() => _minutes;

  @override
  int currentRightIndex() => _seconds;

  @override
  DateTime? finalTime() => _startDateTime
      .add(Duration(hours: _hours, minutes: _minutes, seconds: _seconds));

  @override
  List<int> layoutProportions() => [1, 1, 1];

  @override
  String? leftStringAtIndex(int index) =>
      (index >= 0 && index <= _maxHours) ? "${index}h" : null;

  @override
  String? middleStringAtIndex(int index) =>
      (index >= 0 && index <= 59) ? "${_padLeft(index)}m" : null;

  @override
  String? rightStringAtIndex(int index) =>
      (index >= 0 && index <= 59) ? "${_padLeft(index)}s" : null;

  @override
  String leftDivider() => ":";

  @override
  String rightDivider() => ":";

  @override
  void setLeftIndex(int index) => _hours = index;

  @override
  void setMiddleIndex(int index) => _minutes = index;

  @override
  void setRightIndex(int index) => _seconds = index;

  String _padLeft(int value) => value.toString().padLeft(2, "0");
}
