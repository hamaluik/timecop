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
import 'package:timecop/data_providers/notifications/notifications_provider.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/l10n.dart';
import './bloc.dart';

class TimersBloc extends Bloc<TimersEvent, TimersState> {
  final DataProvider data;
  final SettingsProvider settings;
  final NotificationsProvider notifications;
  TimersBloc(this.data, this.settings, this.notifications) : super(TimersState.initial()) {
    on<LoadTimers>((event, emit) async {
      List<TimerEntry> timers = await data.listTimers();
      emit(TimersState(timers, DateTime.now()));
    });

    on<CreateTimer>((event, emit) async {
      TimerEntry timer = await data.createTimer(
          description: event.description, projectID: event.project?.id);
      List<TimerEntry> timers =
          state.timers.map((t) => TimerEntry.clone(t)).toList();
      timers.add(timer);
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });

    on<UpdateNow>((event, emit) {
      emit(TimersState(state.timers, DateTime.now()));
      List<TimerEntry> activeTimers = state.timers.where((t) => t.endTime == null).toList();
      var nagAboutMissingTimer = settings.getBool("nagAboutMissingTimer") ?? true;
      if (nagAboutMissingTimer && activeTimers.length == 0) {
        var now = DateTime.now();
        if (now.hour >= 9 && now.hour < 17 && now.second == 37 && now.minute % 10 == 2) {
          print("Nagging about missing timer");
          notifications.displayNoRunningTimersNotification(
            "No Running Timers Detected", "You don't have any timers running right now. Click here to start one.",
          );
        }
      }
    });

    on<StopTimer>((event, emit) async {
      TimerEntry timer = TimerEntry.clone(event.timer, endTime: DateTime.now());
      await data.editTimer(timer);
      List<TimerEntry> timers = state.timers.map((t) {
        if (t.id == timer.id) return TimerEntry.clone(timer);
        return TimerEntry.clone(t);
      }).toList();
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });

    on<EditTimer>((event, emit) async {
      await data.editTimer(event.timer);
      List<TimerEntry> timers = state.timers.map((t) {
        if (t.id == event.timer.id) return TimerEntry.clone(event.timer);
        return TimerEntry.clone(t);
      }).toList();
      timers.sort((a, b) => a.startTime.compareTo(b.startTime));
      emit(TimersState(timers, DateTime.now()));
    });

    on<DeleteTimer>((event, emit) async {
      await data.deleteTimer(event.timer);
      List<TimerEntry> timers = state.timers
          .where((t) => t.id != event.timer.id)
          .map((t) => TimerEntry.clone(t))
          .toList();
      emit(TimersState(timers, DateTime.now()));
    });

    on<StopAllTimers>((event, emit) async {
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
      emit(TimersState(timers, DateTime.now()));
    });
  }
}
