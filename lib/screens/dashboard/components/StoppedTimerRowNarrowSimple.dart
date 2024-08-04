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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/timer/TimerEditor.dart';

import 'package:timecop/utils/timer_utils.dart';

class StoppedTimerRowNarrowSimple extends StatefulWidget {
  final TimerEntry timer;
  final Function(BuildContext) resumeTimer;
  final Function(BuildContext) deleteTimer;

  const StoppedTimerRowNarrowSimple(
      {Key? key,
      required this.timer,
      required this.resumeTimer,
      required this.deleteTimer})
      : super(key: key);

  @override
  State<StoppedTimerRowNarrowSimple> createState() =>
      _StoppedTimerRowNarrowSimpleState();
}

class _StoppedTimerRowNarrowSimpleState
    extends State<StoppedTimerRowNarrowSimple> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    assert(widget.timer.endTime != null);

    final theme = Theme.of(context);

    return MouseRegion(
        onEnter: (_) => setState(() {
              _hovering = true;
            }),
        onExit: (_) => setState(() {
              _hovering = false;
            }),
        child: Slidable(
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.15,
            children: <Widget>[
              SlidableAction(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  icon: FontAwesomeIcons.trash,
                  onPressed: widget.deleteTimer)
            ],
          ),
          endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.15,
              children: <Widget>[
                SlidableAction(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    icon: FontAwesomeIcons.play,
                    onPressed: (_) => widget.resumeTimer(context))
              ]),
          child: ListTile(
              key: Key("stoppedTimer-${widget.timer.id}"),
              leading: ProjectColour(
                  project: BlocProvider.of<ProjectsBloc>(context)
                      .getProjectByID(widget.timer.projectID)),
              title: Text(
                  TimerUtils.formatDescription(
                      context, widget.timer.description),
                  style: TimerUtils.styleDescription(
                      context, widget.timer.description)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  widget.timer.formatTime(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                if (_hovering) const SizedBox(width: 4),
                if (_hovering)
                  IconButton(
                      icon: const Icon(FontAwesomeIcons.circlePlay),
                      onPressed: () => widget.resumeTimer(context),
                      tooltip: L10N.of(context).tr.resumeTimer),
              ]),
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
                    builder: (BuildContext context) => TimerEditor(
                      timer: widget.timer,
                    ),
                    fullscreenDialog: true,
                  ))),
        ));
  }
}
