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
import 'package:intl/intl.dart';
import 'package:timecop/models/timer_entry.dart';

class CollapsibleDayGrouping extends StatefulWidget {
  final DateTime date;
  final Iterable<Widget> children;
  final Duration totalTime;

  const CollapsibleDayGrouping(
      {Key? key,
      required this.date,
      required this.children,
      required this.totalTime})
      : super(key: key);

  @override
  State<CollapsibleDayGrouping> createState() => _CollapsibleDayGroupingState();
}

class _CollapsibleDayGroupingState extends State<CollapsibleDayGrouping>
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
    _expanded = DateTime.now().difference(widget.date).inDays.abs() <= 1;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value:
          DateTime.now().difference(widget.date).inDays.abs() <= 1 ? 1.0 : 0.0,
    );
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMEEEEd();
    final theme = Theme.of(context);
    return ExpansionTile(
      initiallyExpanded:
          DateTime.now().difference(widget.date).inDays.abs() <= 1,
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
      title: Text(dateFormat.format(widget.date),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: theme.textTheme.bodyMedium!.fontSize,
          )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RotationTransition(
            turns: _iconTurns,
            child: const Icon(Icons.expand_more),
          ),
          const SizedBox(width: 8),
          Text(TimerEntry.formatDuration(widget.totalTime),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _expanded ? theme.colorScheme.primary : null,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
        ],
      ),
      children: widget.children.toList(),
    );
  }
}
