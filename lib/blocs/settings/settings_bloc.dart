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
import 'package:timecop/blocs/projects/projects_event.dart';
import 'package:timecop/blocs/timers/timers_event.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/data_providers/data/database_provider.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsProvider settings;
  final DataProvider data;
  SettingsBloc(this.settings, this.data);

  @override
  SettingsState get initialState => SettingsState.initial();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is LoadSettingsFromRepository) {
      bool exportGroupTimers = await settings.getBool("exportGroupTimers") ??
          state.exportGroupTimers;
      bool exportIncludeProject =
          await settings.getBool("exportIncludeProject") ??
              state.exportIncludeProject;
      bool exportIncludeDate = await settings.getBool("exportIncludeDate") ??
          state.exportIncludeDate;
      bool exportIncludeDescription =
          await settings.getBool("exportIncludeDescription") ??
              state.exportIncludeDescription;
      bool exportIncludeProjectDescription =
          await settings.getBool("exportIncludeProjectDescription") ??
              state.exportIncludeProjectDescription;
      bool exportIncludeStartTime =
          await settings.getBool("exportIncludeStartTime") ??
              state.exportIncludeStartTime;
      bool exportIncludeEndTime =
          await settings.getBool("exportIncludeEndTime") ??
              state.exportIncludeEndTime;
      bool exportIncludeDurationHours =
          await settings.getBool("exportIncludeDurationHours") ??
              state.exportIncludeDurationHours;
      bool exportIncludeNotes = await settings.getBool("exportIncludeNotes") ??
          state.exportIncludeNotes;
      bool groupTimers =
          await settings.getBool("groupTimers") ?? state.groupTimers;
      bool collapseDays =
          await settings.getBool("collapseDays") ?? state.collapseDays;
      bool autocompleteDescription =
          await settings.getBool("autocompleteDescription") ??
              state.autocompleteDescription;
      bool defaultFilterStartDateToMonday =
          await settings.getBool("defaultFilterStartDateToMonday") ??
              state.defaultFilterStartDateToMonday;
      bool oneTimerAtATime =
          await settings.getBool("oneTimerAtATime") ?? state.oneTimerAtATime;
      bool showBadgeCounts =
          await settings.getBool("showBadgeCounts") ?? state.showBadgeCounts;
      int defaultFilterDays = await settings.getInt("defaultFilterDays") ?? 30;
      bool hasAskedNotificationPermissions =
          await settings.getBool("hasAskedNotificationPermissions") ??
              state.hasAskedNotificationPermissions;
      bool showRunningTimersAsNotifications =
          await settings.getBool("showRunningTimersAsNotifications") ??
              state.showRunningTimersAsNotifications;
      yield SettingsState(
        exportGroupTimers: exportGroupTimers,
        exportIncludeDate: exportIncludeDate,
        exportIncludeProject: exportIncludeProject,
        exportIncludeDescription: exportIncludeDescription,
        exportIncludeProjectDescription: exportIncludeProjectDescription,
        exportIncludeStartTime: exportIncludeStartTime,
        exportIncludeEndTime: exportIncludeEndTime,
        exportIncludeDurationHours: exportIncludeDurationHours,
        exportIncludeNotes: exportIncludeNotes,
        groupTimers: groupTimers,
        collapseDays: collapseDays,
        autocompleteDescription: autocompleteDescription,
        defaultFilterStartDateToMonday: defaultFilterStartDateToMonday,
        oneTimerAtATime: oneTimerAtATime,
        showBadgeCounts: showBadgeCounts,
        defaultFilterDays: defaultFilterDays,
        hasAskedNotificationPermissions: hasAskedNotificationPermissions,
        showRunningTimersAsNotifications: showRunningTimersAsNotifications,
      );
    } else if (event is SetBoolValueEvent) {
      if (event.exportGroupTimers != null) {
        await settings.setBool("exportGroupTimers", event.exportGroupTimers);
      }
      if (event.exportIncludeDate != null) {
        await settings.setBool("exportIncludeDate", event.exportIncludeDate);
      }
      if (event.exportIncludeProject != null) {
        await settings.setBool(
            "exportIncludeProject", event.exportIncludeProject);
      }
      if (event.exportIncludeDescription != null) {
        await settings.setBool(
            "exportIncludeDescription", event.exportIncludeDescription);
      }
      if (event.exportIncludeProjectDescription != null) {
        await settings.setBool("exportIncludeProjectDescription",
            event.exportIncludeProjectDescription);
      }
      if (event.exportIncludeStartTime != null) {
        await settings.setBool(
            "exportIncludeStartTime", event.exportIncludeStartTime);
      }
      if (event.exportIncludeEndTime != null) {
        await settings.setBool(
            "exportIncludeEndTime", event.exportIncludeEndTime);
      }
      if (event.exportIncludeDurationHours != null) {
        await settings.setBool(
            "exportIncludeDurationHours", event.exportIncludeDurationHours);
      }
      if (event.exportIncludeNotes != null) {
        await settings.setBool("exportIncludeNotes", event.exportIncludeNotes);
      }
      if (event.groupTimers != null) {
        await settings.setBool("groupTimers", event.groupTimers);
      }
      if (event.collapseDays != null) {
        await settings.setBool("collapseDays", event.collapseDays);
      }
      if (event.autocompleteDescription != null) {
        await settings.setBool(
            "autocompleteDescription", event.autocompleteDescription);
      }
      if (event.defaultFilterStartDateToMonday != null) {
        await settings.setBool("defaultFilterStartDateToMonday",
            event.defaultFilterStartDateToMonday);
      }
      if (event.oneTimerAtATime != null) {
        await settings.setBool("oneTimerAtATime", event.oneTimerAtATime);
      }
      bool hasAskedNotificationPermissions =
          state.hasAskedNotificationPermissions;
      if (event.showBadgeCounts != null) {
        await settings.setBool("showBadgeCounts", event.showBadgeCounts);
        if (event.showBadgeCounts) {
          // trigger a notification permission window
          FlutterAppBadger.removeBadge();
          await settings.setBool("hasAskedNotificationPermissions", true);
          hasAskedNotificationPermissions = true;
        }
      }
      if (event.showRunningTimersAsNotifications != null) {
        await settings.setBool("showRunningTimersAsNotifications",
            event.showRunningTimersAsNotifications);
        if (event.showRunningTimersAsNotifications) {
          // trigger a notification permission window
          FlutterAppBadger.removeBadge();
          await settings.setBool("hasAskedNotificationPermissions", true);
          hasAskedNotificationPermissions = true;
        }
      }
      yield SettingsState.clone(
        state,
        exportGroupTimers: event.exportGroupTimers,
        exportIncludeDate: event.exportIncludeDate,
        exportIncludeProject: event.exportIncludeProject,
        exportIncludeDescription: event.exportIncludeDescription,
        exportIncludeProjectDescription: event.exportIncludeProjectDescription,
        exportIncludeStartTime: event.exportIncludeStartTime,
        exportIncludeEndTime: event.exportIncludeEndTime,
        exportIncludeDurationHours: event.exportIncludeDurationHours,
        groupTimers: event.groupTimers,
        collapseDays: event.collapseDays,
        autocompleteDescription: event.autocompleteDescription,
        defaultFilterStartDateToMonday: event.defaultFilterStartDateToMonday,
        oneTimerAtATime: event.oneTimerAtATime,
        showBadgeCounts: event.showBadgeCounts,
        hasAskedNotificationPermissions: hasAskedNotificationPermissions,
        showRunningTimersAsNotifications:
            event.showRunningTimersAsNotifications,
      );
    } else if (event is SetDefaultFilterDays) {
      await settings.setInt("defaultFilterDays", event.days ?? -1);
      yield SettingsState.clone(state, defaultFilterDays: event.days ?? -1);
    } else if (event is ImportDatabaseEvent) {
      final DatabaseProvider importData =
          await DatabaseProvider.open(event.path);
      await data.import(importData);
      event.projects.add(LoadProjects());
      event.timers.add(LoadTimers());
      await importData.close();
      yield SettingsState.clone(state);
    }
  }

  DateTime getFilterStartDate() {
    if (state.defaultFilterStartDateToMonday) {
      var dayOfWeek = 1; // Monday=1, Tuesday=2...
      DateTime date = DateTime.now();
      return date.subtract(Duration(days: date.weekday - dayOfWeek));
    } else if (state.defaultFilterDays > 0) {
      return DateTime.now().subtract(Duration(days: 30));
    } else {
      return null;
    }
  }
}
