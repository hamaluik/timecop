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
import 'package:timecop/data_providers/settings/settings_provider.dart';

import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsProvider settings;

  SettingsBloc(this.settings);

  @override
  SettingsState get initialState => SettingsState.initial();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is LoadSettingsFromRepository) {
      bool exportGroupTimers = await settings.getBool("exportGroupTimers") ??
          state.exportGroupTimers;
      bool exportIncludeDateRangeInFilename =
          await settings.getBool("exportIncludeDateRangeInFilename") ??
              state.exportIncludeDateRangeInFilename;
      bool exportIncludeTimeInFilename =
          await settings.getBool("exportIncludeTimeInFilename") ??
              state.exportIncludeTimeInFilename;
      bool exportTimesheet =
          await settings.getBool("exportTimesheet") ?? state.exportTimesheet;
      bool exportIncludeProject =
          await settings.getBool("exportIncludeProject") ??
              state.exportIncludeProject;
      bool exportIncludeWorkType =
          await settings.getBool("exportIncludeWorkType") ??
              state.exportIncludeWorkType;
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
      int defaultProjectID =
          await settings.getInt("defaultProjectID") ?? state.defaultProjectID;
      int defaultWorkTypeID =
          await settings.getInt("defaultWorkTypeID") ?? state.defaultWorkTypeID;
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
      bool allowMultipleActiveTimers =
          await settings.getBool("allowMultipleActiveTimers") ??
              state.allowMultipleActiveTimers;
      bool displayProjectNameInTimer =
          await settings.getBool("displayProjectNameInTimer") ??
              state.displayProjectNameInTimer;
      yield SettingsState(
          exportGroupTimers: exportGroupTimers,
          exportIncludeDateRangeInFilename: exportIncludeDateRangeInFilename,
          exportIncludeTimeInFilename: exportIncludeTimeInFilename,
          exportTimesheet: exportTimesheet,
          exportIncludeDate: exportIncludeDate,
          exportIncludeProject: exportIncludeProject,
          exportIncludeWorkType: exportIncludeWorkType,
          exportIncludeDescription: exportIncludeDescription,
          exportIncludeProjectDescription: exportIncludeProjectDescription,
          exportIncludeStartTime: exportIncludeStartTime,
          exportIncludeEndTime: exportIncludeEndTime,
          exportIncludeDurationHours: exportIncludeDurationHours,
          defaultProjectID: defaultProjectID,
          defaultWorkTypeID: defaultWorkTypeID,
          groupTimers: groupTimers,
          collapseDays: collapseDays,
          autocompleteDescription: autocompleteDescription,
          defaultFilterStartDateToMonday: defaultFilterStartDateToMonday,
          allowMultipleActiveTimers: allowMultipleActiveTimers,
          displayProjectNameInTimer: displayProjectNameInTimer);
    } else if (event is SetDefaultProjectID) {
      await settings.setInt("defaultProjectID", event.projectID ?? -1);
      yield SettingsState.clone(state, defaultProjectID: event.projectID ?? -1);
    } else if (event is SetDefaultWorkTypeID) {
      await settings.setInt("defaultWorkTypeID", event.workTypeID ?? -1);
      yield SettingsState.clone(state,
          defaultWorkTypeID: event.workTypeID ?? -1);
    } else if (event is SetBoolValueEvent) {
      if (event.exportGroupTimers != null) {
        await settings.setBool("exportGroupTimers", event.exportGroupTimers);
      }
      if (event.exportIncludeDateRangeInFilename != null) {
        await settings.setBool("exportIncludeDateRangeInFilename",
            event.exportIncludeDateRangeInFilename);
      }
      if (event.exportIncludeTimeInFilename != null) {
        await settings.setBool(
            "exportIncludeTimeInFilename", event.exportIncludeTimeInFilename);
      }
      if (event.exportTimesheet != null) {
        await settings.setBool("exportTimesheet", event.exportTimesheet);
      }
      if (event.exportIncludeDate != null) {
        await settings.setBool("exportIncludeDate", event.exportIncludeDate);
      }
      if (event.exportIncludeProject != null) {
        await settings.setBool(
            "exportIncludeProject", event.exportIncludeProject);
      }
      if (event.exportIncludeWorkType != null) {
        await settings.setBool(
            "exportIncludeWorkType", event.exportIncludeWorkType);
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
      if (event.allowMultipleActiveTimers != null) {
        await settings.setBool(
            "allowMultipleActiveTimers", event.allowMultipleActiveTimers);
      }
      if (event.displayProjectNameInTimer != null) {
        await settings.setBool(
            "displayProjectNameInTimer", event.displayProjectNameInTimer);
      }
      yield SettingsState.clone(
        state,
        exportGroupTimers: event.exportGroupTimers,
        exportIncludeDateRangeInFilename:
            event.exportIncludeDateRangeInFilename,
        exportIncludeTimeInFilename: event.exportIncludeTimeInFilename,
        exportTimesheet: event.exportTimesheet,
        exportIncludeDate: event.exportIncludeDate,
        exportIncludeProject: event.exportIncludeProject,
        exportIncludeWorkType: event.exportIncludeWorkType,
        exportIncludeDescription: event.exportIncludeDescription,
        exportIncludeProjectDescription: event.exportIncludeProjectDescription,
        exportIncludeStartTime: event.exportIncludeStartTime,
        exportIncludeEndTime: event.exportIncludeEndTime,
        exportIncludeDurationHours: event.exportIncludeDurationHours,
        groupTimers: event.groupTimers,
        collapseDays: event.collapseDays,
        autocompleteDescription: event.autocompleteDescription,
        defaultFilterStartDateToMonday: event.defaultFilterStartDateToMonday,
        allowMultipleActiveTimers: event.allowMultipleActiveTimers,
        displayProjectNameInTimer: event.displayProjectNameInTimer,
      );
    }
  }

  /**
   * return the start date for a date filter with time set to 00:00:00.000.
   * If setting defaultFilterStartDateToMonday is true, then return Monday of
   * the current week (week starts on Monday). Otherwise, return 30 days prior to
   * today.
   */
  DateTime getFilterStartDate() {
    DateTime now = DateTime.now();
    DateTime todayZerothHour =
        DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    DateTime startDate;
    if (state.defaultFilterStartDateToMonday) {
      var dayOfWeek = 1; // Monday=1, Tuesday=2...
      startDate = todayZerothHour
          .subtract(Duration(days: todayZerothHour.weekday - dayOfWeek));
    } else {
      startDate = todayZerothHour.subtract(Duration(days: 30));
    }
    return startDate;
  }
}
