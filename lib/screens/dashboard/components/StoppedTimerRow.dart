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
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';
import 'package:timecop/blocs/timers/timers_event.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/utils/responsiveness_utils.dart';
import 'package:timecop/screens/dashboard/components/StoppedTimerRowNarrowDense.dart';
import 'package:timecop/screens/dashboard/components/StoppedTimerRowNarrowSimple.dart';
import 'package:timecop/screens/dashboard/components/StoppedTimerRowWide.dart';

class StoppedTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final bool isWidescreen;
  final bool showProjectName;

  const StoppedTimerRow(
      {Key? key,
      required this.timer,
      required this.isWidescreen,
      required this.showProjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivenessUtils.isWidescreen(context)
        ? StoppedTimerRowWide(
            timer: timer,
            resumeTimer: _resumeTimer,
            deleteTimer: _deleteTimer,
            showProjectName: showProjectName)
        : BlocProvider.of<SettingsBloc>(context).state.showProjectNames
            ? StoppedTimerRowNarrowDense(
                timer: timer,
                resumeTimer: _resumeTimer,
                deleteTimer: _deleteTimer)
            : StoppedTimerRowNarrowSimple(
                timer: timer,
                resumeTimer: _resumeTimer,
                deleteTimer: _deleteTimer);
  }

  void _resumeTimer(BuildContext context) {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    Project? project = projectsBloc.getProjectByID(timer.projectID);
    if (settingsBloc.state.oneTimerAtATime) {
      timersBloc.add(const StopAllTimers());
    }
    timersBloc
        .add(CreateTimer(description: timer.description, project: project));
  }

  void _deleteTimer(BuildContext context) async {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final bool delete = await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(L10N.of(context).tr.confirmDelete),
                  content: Text(L10N.of(context).tr.deleteTimerConfirm),
                  actions: <Widget>[
                    TextButton(
                      child: Text(L10N.of(context).tr.cancel),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text(L10N.of(context).tr.delete),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ))) ??
        false;
    if (delete) {
      timersBloc.add(DeleteTimer(timer));
    }
  }
}
