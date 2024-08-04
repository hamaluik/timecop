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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/dashboard/components/ProjectTag.dart';
import 'package:timecop/screens/dashboard/components/RowSeparator.dart';
import 'package:timecop/screens/timer/TimerEditor.dart';
import 'package:timecop/themes.dart';

import 'package:timecop/utils/timer_utils.dart';

class StoppedTimerRowWide extends StatelessWidget {
  static const _spaceWidth = 16.0;

  final TimerEntry timer;
  final Function(BuildContext) resumeTimer;
  final Function(BuildContext) deleteTimer;
  final bool showProjectName;

  const StoppedTimerRowWide(
      {Key? key,
      required this.timer,
      required this.resumeTimer,
      required this.deleteTimer,
      required this.showProjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(timer.endTime != null);
    final theme = Theme.of(context);

    final duration = timer.endTime!.difference(timer.startTime);
    final timeSpanStyle = theme.textTheme.bodyMedium?.copyWith(
      color: ThemeUtil.getOnBackgroundLighter(context),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final project =
        BlocProvider.of<ProjectsBloc>(context).getProjectByID(timer.projectID);
    final timeFormat = DateFormat.jm();

    return ListTile(
        key: Key("stoppedTimer-${timer.id}"),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
              builder: (BuildContext context) => TimerEditor(
                timer: timer,
              ),
              fullscreenDialog: true,
            )),
        leading: showProjectName ? null : ProjectColour(project: project),
        title: showProjectName
            ? Row(children: [
                Flexible(
                    child: Text(
                        TimerUtils.formatDescription(
                            context, timer.description),
                        style: TimerUtils.styleDescription(
                            context, timer.description))),
                const SizedBox(width: _spaceWidth),
                ProjectTag(project: project)
              ])
            : Text(TimerUtils.formatDescription(context, timer.description),
                style: TimerUtils.styleDescription(context, timer.description)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: _spaceWidth),
            Text(
              timeFormat.format(timer.startTime),
              style: timeSpanStyle,
            ),
            const SizedBox(
              width: _spaceWidth,
            ),
            const Text("-"),
            const SizedBox(
              width: _spaceWidth,
            ),
            Text(
              timeFormat.format(timer.endTime!),
              style: timeSpanStyle,
            ),
            if (duration.inDays > 0)
              Transform.translate(
                offset: const Offset(2, -4),
                child: Text(
                  "+${duration.inDays}",
                  textScaler: const TextScaler.linear(0.8),
                  style: timeSpanStyle,
                ),
              ),
            const SizedBox(width: _spaceWidth),
            const RowSeparator(),
            const SizedBox(width: _spaceWidth),
            Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: Text(
                timer.formatTime(),
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(width: _spaceWidth),
            const RowSeparator(),
            const SizedBox(width: _spaceWidth),
            IconButton(
                icon: const Icon(FontAwesomeIcons.trash),
                onPressed: () => deleteTimer(context),
                tooltip: L10N.of(context).tr.delete),
            const SizedBox(width: _spaceWidth),
            IconButton(
                icon: const Icon(FontAwesomeIcons.circlePlay),
                onPressed: () => resumeTimer(context),
                tooltip: L10N.of(context).tr.resumeTimer),
          ],
        ));
  }
}
