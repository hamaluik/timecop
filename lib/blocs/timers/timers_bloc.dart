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

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/models/timer_entry.dart';
import './bloc.dart';

class TimersBloc extends Bloc<TimersEvent, TimersState> {
  final DataProvider data;
  final SettingsProvider settings;
  TimersBloc(this.data, this.settings);

  @override
  TimersState get initialState => TimersState.initial();

  @override
  Stream<TimersState> mapEventToState(
    TimersEvent event,
  ) async* {
    if (event is LoadTimers) {
      List<TimerEntry> timers = await data.listTimers();
      yield TimersState(timers, DateTime.now());
    } else if (event is CreateTimer) {
      TimerEntry timer = await data.createTimer(
          description: event.description, projectID: event.project?.id);
      List<TimerEntry> timers =
          state.timers.map((t) => TimerEntry.clone(t)).toList();
      timers.add(timer);
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield TimersState(timers, DateTime.now());
    } else if (event is UpdateNow) {
      yield TimersState(state.timers, DateTime.now());
    } else if (event is StopTimer) {
      TimerEntry timer = TimerEntry.clone(event.timer, endTime: DateTime.now());
      await data.editTimer(timer);
      List<TimerEntry> timers = state.timers.map((t) {
        if (t.id == timer.id) return TimerEntry.clone(timer);
        return TimerEntry.clone(t);
      }).toList();
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield TimersState(timers, DateTime.now());
    } else if (event is EditTimer) {
      await data.editTimer(event.timer);
      List<TimerEntry> timers = state.timers.map((t) {
        if (t.id == event.timer.id) return TimerEntry.clone(event.timer);
        return TimerEntry.clone(t);
      }).toList();
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield TimersState(timers, DateTime.now());
    } else if (event is DeleteTimer) {
      await data.deleteTimer(event.timer);
      List<TimerEntry> timers = state.timers
          .where((t) => t.id != event.timer.id)
          .map((t) => TimerEntry.clone(t))
          .toList();
      yield TimersState(timers, DateTime.now());
    } else if (event is StopAllTimers) {
      List<Future<TimerEntry>> timerEdits = state.timers.map((t) async {
        if (t.endTime == null) {
          TimerEntry timer = TimerEntry.clone(t, endTime: DateTime.now());
          await data.editTimer(timer);
          return timer;
        }
        return TimerEntry.clone(t);
      }).toList();

      List<TimerEntry> timers = await Future.wait(timerEdits);
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      yield TimersState(timers, DateTime.now());
    }
  }
}
