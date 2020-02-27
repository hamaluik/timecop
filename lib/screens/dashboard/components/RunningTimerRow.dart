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
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/models/timer_entry.dart';

class RunningTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final DateTime now;
  const RunningTimerRow({Key key, @required this.timer, @required this.now})
    : assert(timer != null),
      assert(now != null),
      super(key: key);

  static String formatDescription(String description) {
    if(description == null || description.trim().isEmpty) {
      return "(no description)";
    }
    return description;
  }

  static String formatDuration(Duration d) {
    return
        d.inHours.toString().padLeft(2, "0") + "h"
      + (d.inMinutes - (d.inHours * 60)).toString().padLeft(2, "0") + "m"
      + (d.inSeconds - (d.inMinutes * 60)).toString().padLeft(2, "0") + "s";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(formatDescription(timer.description)),
          ),
        ),
        Text(formatDuration(now.difference(timer.startTime)), style: TextStyle(fontFamily: "FiraMono")),
        IconButton(
          icon: Icon(FontAwesomeIcons.solidStopCircle),
          onPressed: () {
            final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
            assert(timers != null);
            timers.add(StopTimer(timer));
          },
        )
      ],
    );
  }
}