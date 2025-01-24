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
import 'package:timecop/screens/dashboard/components/StoppedTimerRow.dart';

import 'package:timecop/utils/timer_utils.dart';

class GroupedStoppedTimersRowNarrowSimple extends StatefulWidget {
  final List<TimerEntry> timers;
  final Function(BuildContext) resumeTimer;
  final Duration totalDuration;

  const GroupedStoppedTimersRowNarrowSimple(
      {Key? key,
      required this.timers,
      required this.resumeTimer,
      required this.totalDuration})
      : assert(timers.length > 1),
        super(key: key);

  @override
  State<GroupedStoppedTimersRowNarrowSimple> createState() =>
      _GroupedStoppedTimersRowNarrowSimpleState();
}

class _GroupedStoppedTimersRowNarrowSimpleState
    extends State<GroupedStoppedTimersRowNarrowSimple>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: -0.5);

  bool _isHovering = false;
  late bool _expanded;

  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _expanded = false;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
        onEnter: (_) => setState(() {
              _isHovering = true;
            }),
        onExit: (_) => setState(() {
              _isHovering = false;
            }),
        child: Slidable(
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
          child: ExpansionTile(
            onExpansionChanged: (expanded) {
              setState(() {
                _expanded = expanded;
                if (_expanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
            leading: ProjectColour(
                project: BlocProvider.of<ProjectsBloc>(context)
                    .getProjectByID(widget.timers[0].projectID)),
            title: Text(
                TimerUtils.formatDescription(
                    context, widget.timers[0].description),
                style: TimerUtils.styleDescription(
                    context, widget.timers[0].description)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RotationTransition(
                  turns: _iconTurns,
                  child: const Icon(
                    Icons.expand_more,
                  ),
                ),
                const SizedBox(width: 4),
                Text(TimerEntry.formatDuration(widget.totalDuration),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    )),
                if (_isHovering && !_expanded) const SizedBox(width: 4),
                if (_isHovering && !_expanded)
                  IconButton(
                      icon: const Icon(FontAwesomeIcons.circlePlay),
                      onPressed: () => widget.resumeTimer(context),
                      tooltip: L10N.of(context).tr.resumeTimer),
              ],
            ),
            children: widget.timers
                .map((timer) => StoppedTimerRow(
                      timer: timer,
                      isWidescreen: false,
                      showProjectName: false,
                    ))
                .toList(),
          ),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
