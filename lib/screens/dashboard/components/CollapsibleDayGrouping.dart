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
  CollapsibleDayGrouping(
      {Key key,
      @required this.date,
      @required this.children,
      @required this.totalTime})
      : assert(date != null),
        assert(children != null),
        assert(totalTime != null),
        super(key: key);

  @override
  _CollapsibleDayGroupingState createState() => _CollapsibleDayGroupingState();
}

class _CollapsibleDayGroupingState extends State<CollapsibleDayGrouping>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: -0.5);
  static final DateFormat _dateFormat = DateFormat.yMMMMEEEEd();

  bool _expanded;
  AnimationController _controller;
  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _expanded = DateTime.now().difference(widget.date).inDays.abs() <= 1;
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
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
      title: Text(_dateFormat.format(widget.date),
          style: TextStyle(
            //color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w700,
            fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
          )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RotationTransition(
            turns: _iconTurns,
            child: const Icon(Icons.expand_more),
          ),
          Container(width: 8),
          Text(TimerEntry.formatDuration(widget.totalTime),
              style: TextStyle(
                color: _expanded ? Theme.of(context).accentColor : null,
                fontFamily: "FiraMono",
              )),
        ],
      ),
      children: widget.children.toList(),
    );
  }
}
