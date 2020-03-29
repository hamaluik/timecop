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
import 'package:flutter_speed_dial_material_design/flutter_speed_dial_material_design.dart';
//import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class StartTimerButton extends StatefulWidget {
  StartTimerButton({Key key}) : super(key: key);

  @override
  _StartTimerButtonState createState() => _StartTimerButtonState();
}

class _StartTimerButtonState extends State<StartTimerButton> {
  bool _speedDialOpened;

  @override
  void initState() { 
    super.initState();
    _speedDialOpened = false;
  }

  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    assert(bloc != null);

    return BlocBuilder<TimersBloc, TimersState>(
      builder: (BuildContext context, TimersState timersState) {
        if(timersState.timers.where((t) => t.endTime == null).isEmpty) {
          return FloatingActionButton(
            key: Key("startTimerButton"),
            child: Stack(
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 18,
                  child: Icon(FontAwesomeIcons.play),
                )
              ],
            ),
            backgroundColor: Theme.of(context).accentColor,
            foregroundColor: Theme.of(context).accentIconTheme.color,
            onPressed: () {
              final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
              assert(timers != null);

              timers.add(CreateTimer(description: bloc.state.newDescription, project: bloc.state.newProject));
              bloc.add(TimerWasStartedEvent());
            },
          );
        }
        else {
          /*return SpeedDial(
            marginRight: 14,
            overlayColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundColor: _speedDialOpened ? Theme.of(context).disabledColor : Theme.of(context).accentColor,
            foregroundColor: Theme.of(context).accentIconTheme.color,
            onOpen: () => setState(() => _speedDialOpened = true),
            onClose: () => setState(() => _speedDialOpened = false),
            child: Stack(
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 16,
                  child: Icon(FontAwesomeIcons.stopwatch),
                )
              ],
            ),
            children: <SpeedDialChild>[
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.plus),
                backgroundColor: Theme.of(context).accentColor,
                foregroundColor: Theme.of(context).accentIconTheme.color,
                onTap: () {
                  final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
                  assert(timers != null);

                  timers.add(CreateTimer(description: bloc.state.newDescription, project: bloc.state.newProject));
                  bloc.add(TimerWasStartedEvent());
                },
              ),
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.stop),
                backgroundColor: Colors.pink[600],
                foregroundColor: Theme.of(context).accentIconTheme.color,
                onTap: () {
                  final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
                  assert(timers != null);
                  timers.add(StopAllTimers());
                },
              ),
            ],
          );*/
          return SpeedDialFloatingActionButton(
            onAction: (int action) {
              final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
              assert(timers != null);
              switch(action) {
                case 0: {
                  timers.add(CreateTimer(description: bloc.state.newDescription, project: bloc.state.newProject));
                  bloc.add(TimerWasStartedEvent());
                }
                break;
                case 1: {
                  timers.add(StopAllTimers());
                }
                break;
              }
            },
            actions: <SpeedDialAction>[
              SpeedDialAction(
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Theme.of(context).accentColor,
                )
              ),
              SpeedDialAction(
                child: Icon(
                  FontAwesomeIcons.stop,
                  color: Colors.pink[600],
                ),
              )
            ],
            childOnFold: Stack(
              key: UniqueKey(),
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 16,
                  child: Icon(FontAwesomeIcons.stopwatch),
                )
              ],
            ),
            childOnUnfold: Stack(
              key: UniqueKey(),
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 16,
                  child: Icon(FontAwesomeIcons.times),
                )
              ],
            ),
          );
        }
      }
    );
  }
}
