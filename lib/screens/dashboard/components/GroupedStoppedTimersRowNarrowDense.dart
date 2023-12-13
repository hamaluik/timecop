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
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/dashboard/components/ProjectTag.dart';
import 'package:timecop/screens/dashboard/components/StoppedTimerRow.dart';
import 'package:timecop/screens/dashboard/components/TimerDenseTrailing.dart';

import 'package:timecop/utils/timer_utils.dart';

class GroupedStoppedTimersRowNarrowDense extends StatefulWidget {
  final List<TimerEntry> timers;
  final Function(BuildContext) resumeTimer;
  final Duration totalDuration;

  const GroupedStoppedTimersRowNarrowDense(
      {Key? key,
      required this.timers,
      required this.resumeTimer,
      required this.totalDuration})
      : assert(timers.length > 1),
        super(key: key);

  @override
  State<GroupedStoppedTimersRowNarrowDense> createState() =>
      _GroupedStoppedTimersRowNarrowDenseState();
}

class _GroupedStoppedTimersRowNarrowDenseState
    extends State<GroupedStoppedTimersRowNarrowDense>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: -0.5);

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
    final project = BlocProvider.of<ProjectsBloc>(context)
        .getProjectByID(widget.timers[0].projectID);
    final directionality = Directionality.of(context);
    final tilePadding = Theme.of(context)
        .expansionTileTheme
        .tilePadding
        ?.resolve(directionality);

    return ExpansionTile(
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
      tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      title: Padding(
          padding: EdgeInsetsDirectional.only(
              start: (directionality == TextDirection.ltr
                      ? tilePadding?.left
                      : tilePadding?.right) ??
                  16,
              top: tilePadding?.top ?? 0,
              bottom: tilePadding?.bottom ?? 0),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      TimerUtils.formatDescription(
                          context, widget.timers[0].description),
                      style: TimerUtils.styleDescription(
                          context, widget.timers[0].description)),
                  const SizedBox(height: 8),
                  ProjectTag(project: project)
                ])),
            const SizedBox(width: 8),
            RotationTransition(
              turns: _iconTurns,
              child: const Icon(
                Icons.expand_more,
              ),
            ),
          ])),
      trailing: TimerDenseTrailing(
          durationString: TimerEntry.formatDuration(widget.totalDuration),
          resumeTimer: widget.resumeTimer),
      children: widget.timers
          .map((timer) => StoppedTimerRow(
              timer: timer, isWidescreen: false, showProjectName: true))
          .toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
