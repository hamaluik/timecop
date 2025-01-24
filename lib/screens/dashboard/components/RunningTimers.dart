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
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

import 'RunningTimerRow.dart';

class RunningTimers extends StatelessWidget {
  const RunningTimers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (BuildContext context, DashboardState dashboardState) {
        if (dashboardState.searchString != null) {
          return const SizedBox();
        }

        return BlocBuilder<TimersBloc, TimersState>(
          builder: (BuildContext context, TimersState timersState) {
            final theme = Theme.of(context);

            List<TimerEntry> runningTimers = timersState.timers
                .where((timer) => timer.endTime == null)
                .toList();
            if (runningTimers.isEmpty) {
              return const SizedBox();
            }

            DateTime now = DateTime.now();
            Duration runningTotal = Duration(
                seconds: runningTimers.fold(
                    0,
                    (int sum, TimerEntry t) =>
                        sum + now.difference(t.startTime).inSeconds));

            return Material(
              elevation: 4,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(L10N.of(context).tr.runningTimers,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w700)),
                              Text(TimerEntry.formatDuration(runningTotal),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ],
                                  ))
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    Theme(
                        data: Theme.of(context).copyWith(
                            scrollbarTheme: ScrollbarThemeData(
                                thumbVisibility:
                                    WidgetStateProperty.all<bool>(true))),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.sizeOf(context).height / 4),
                          child: ListView(
                            shrinkWrap: true,
                            children: runningTimers
                                .map((timer) => RunningTimerRow(
                                    timer: timer, now: timersState.now))
                                .toList(),
                          ),
                        )),
                  ]),
            );
          },
        );
      },
    );
  }
}
