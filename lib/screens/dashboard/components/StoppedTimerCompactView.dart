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
import 'package:timecop/timer_utils.dart';

class StoppedTimerCompactView extends StatefulWidget {
  final TimerEntry timer;
  final Function(BuildContext) resumeTimer;
  final Function(BuildContext) deleteTimer;

  const StoppedTimerCompactView({Key? key, required this.timer, required this.resumeTimer, required this.deleteTimer})
      : super(key: key);

  @override
  State<StoppedTimerCompactView> createState() => _StoppedTimerCompactViewState();
}

class _StoppedTimerCompactViewState extends State<StoppedTimerCompactView> {
  static const _spaceWidth = 2.0;
  static final DateFormat _timeFormat = DateFormat("hh:mma");
  final verticalSpacer = const SizedBox(
    height: 8,
  );
  final horizontalSpacer = const SizedBox(
    width: 8,
  );

  @override
  Widget build(BuildContext context) {
    assert(widget.timer.endTime != null);
    final timeSpanStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final duration = widget.timer.endTime!.difference(widget.timer.startTime);
    final project = BlocProvider.of<ProjectsBloc>(context).getProjectByID(widget.timer.projectID);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        verticalSpacer,
        Row(
          children: [
            horizontalSpacer,
            Text(TimerUtils.formatDescription(context, widget.timer.description),
                style: TimerUtils.styleDescription(context, widget.timer.description)),
            const Spacer(),
            Text(
              widget.timer.formatTime(),
              style: TimerUtils.styleDescription(context, widget.timer.description),
            ),
            horizontalSpacer,
          ],
        ),
        const SizedBox(
          height: _spaceWidth,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            horizontalSpacer,
            SizedBox(
              width: 12,
              child: ProjectColour(
                project: project,
              ),
            ),
            horizontalSpacer,
            Text(project?.name ?? "", style: timeSpanStyle),
            const Spacer(),
            Text(
              _timeFormat.format(widget.timer.startTime),
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
              _timeFormat.format(widget.timer.endTime!),
              style: timeSpanStyle,
            ),
            if (duration.inDays > 0)
              Transform.translate(
                offset: const Offset(2, -4),
                child: Text(
                  "+${duration.inDays}",
                  textScaleFactor: 0.8,
                  style: timeSpanStyle,
                ),
              ),
            const SizedBox(width: _spaceWidth),
            SizedBox(
              height: 24,
              child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.play,
                    size: 12,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () => widget.resumeTimer(context),
                  tooltip: L10N.of(context).tr.resumeTimer),
            ),
            horizontalSpacer,
          ],
        ),
        verticalSpacer,
      ],
    );
  }
}
