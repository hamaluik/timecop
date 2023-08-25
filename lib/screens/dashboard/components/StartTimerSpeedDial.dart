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
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class StartTimerSpeedDial extends StatefulWidget {
  const StartTimerSpeedDial({Key? key}) : super(key: key);

  @override
  State<StartTimerSpeedDial> createState() => _StartTimerSpeedDialState();
}

class _StartTimerSpeedDialState extends State<StartTimerSpeedDial>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    // adapted from https://stackoverflow.com/a/46480722
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        height: 70.0,
        width: 56.0,
        alignment: FractionalOffset.topCenter,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            tooltip: L10N.of(context).tr.startNewTimer,
            heroTag: null,
            mini: true,
            onPressed: () {
              _controller.reverse();
              final timers = BlocProvider.of<TimersBloc>(context);
              timers.add(CreateTimer(
                  description: bloc.state.newDescription,
                  project: bloc.state.newProject));
              bloc.add(const TimerWasStartedEvent());
            },
            child: const Stack(
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 7.5,
                  left: 8,
                  child: Icon(FontAwesomeIcons.plus),
                )
              ],
            ),
          ),
        ),
      ),
      Container(
        height: 70.0,
        width: 56.0,
        alignment: FractionalOffset.topCenter,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            tooltip: L10N.of(context).tr.stopAllTimers,
            heroTag: null,
            mini: true,
            backgroundColor: Colors.pink[600],
            foregroundColor: Colors.white,
            onPressed: () {
              _controller.reverse();
              final timers = BlocProvider.of<TimersBloc>(context);
              timers.add(const StopAllTimers());
            },
            child: const Stack(
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 7,
                  left: 7.5,
                  child: Icon(FontAwesomeIcons.stop),
                )
              ],
            ),
          ),
        ),
      ),
      AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext conext, Widget? child) {
          return FloatingActionButton(
            tooltip: (_controller.isDismissed)
                ? L10N.of(context).tr.timerMenu
                : L10N.of(context).tr.closeMenu,
            heroTag: null,
            backgroundColor: _controller.isDismissed
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            foregroundColor: _controller.isDismissed
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            child: _controller.isDismissed
                ? const Stack(
                    // shenanigans to properly centre the icon (font awesome glyphs are variable
                    // width but the library currently doesn't deal with that)
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                        top: 15,
                        left: 16,
                        child: Icon(
                          FontAwesomeIcons.stopwatch,
                        ),
                      )
                    ],
                  )
                : const Stack(
                    // shenanigans to properly centre the icon (font awesome glyphs are variable
                    // width but the library currently doesn't deal with that)
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                        top: 15,
                        left: 16,
                        child: Icon(FontAwesomeIcons.xmark),
                      )
                    ],
                  ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          );
        },
      ),
    ]);
  }
}
