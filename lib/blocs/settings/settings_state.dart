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

import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool exportGroupTimers;
  final bool exportIncludeDate;
  final bool exportIncludeProject;
  final bool exportIncludeDescription;
  final bool exportIncludeProjectDescription;
  final bool exportIncludeStartTime;
  final bool exportIncludeEndTime;
  final bool exportIncludeDurationHours;
  final bool exportIncludeNotes;
  final bool groupTimers;
  final bool collapseDays;
  final bool autocompleteDescription;
  final bool defaultFilterStartDateToMonday;
  final bool oneTimerAtATime;
  final bool showBadgeCounts;
  final int defaultFilterDays;
  final bool hasAskedNotificationPermissions;
  final bool showRunningTimersAsNotifications;
  final bool showProjectNames;
  final bool nagAboutMissingTimer;

  const SettingsState({
    required this.exportGroupTimers,
    required this.exportIncludeDate,
    required this.exportIncludeProject,
    required this.exportIncludeDescription,
    required this.exportIncludeProjectDescription,
    required this.exportIncludeStartTime,
    required this.exportIncludeEndTime,
    required this.exportIncludeDurationHours,
    required this.exportIncludeNotes,
    required this.groupTimers,
    required this.collapseDays,
    required this.autocompleteDescription,
    required this.defaultFilterStartDateToMonday,
    required this.oneTimerAtATime,
    required this.showBadgeCounts,
    required this.defaultFilterDays,
    required this.hasAskedNotificationPermissions,
    required this.showRunningTimersAsNotifications,
    required this.showProjectNames,
    required this.nagAboutMissingTimer,
  });

  static SettingsState initial() {
    return const SettingsState(
      exportGroupTimers: true,
      exportIncludeDate: true,
      exportIncludeProject: true,
      exportIncludeDescription: true,
      exportIncludeProjectDescription: false,
      exportIncludeStartTime: false,
      exportIncludeEndTime: false,
      exportIncludeDurationHours: true,
      exportIncludeNotes: true,
      groupTimers: true,
      collapseDays: false,
      autocompleteDescription: true,
      defaultFilterStartDateToMonday: false,
      oneTimerAtATime: false,
      showBadgeCounts: false,
      defaultFilterDays: 30,
      hasAskedNotificationPermissions: false,
      showRunningTimersAsNotifications: false,
      showProjectNames: false,
      nagAboutMissingTimer: false,
    );
  }

  SettingsState.clone(
    SettingsState settings, {
    bool? exportGroupTimers,
    bool? exportIncludeDate,
    bool? exportIncludeProject,
    bool? exportIncludeDescription,
    bool? exportIncludeProjectDescription,
    bool? exportIncludeStartTime,
    bool? exportIncludeEndTime,
    bool? exportIncludeDurationHours,
    bool? exportIncludeNotes,
    bool? groupTimers,
    bool? collapseDays,
    bool? autocompleteDescription,
    bool? defaultFilterStartDateToMonday,
    bool? oneTimerAtATime,
    bool? showBadgeCounts,
    int? defaultFilterDays,
    bool? hasAskedNotificationPermissions,
    bool? showRunningTimersAsNotifications,
    bool? showProjectNames,
    bool? nagAboutMissingTimer,
  }) : this(
          exportGroupTimers: exportGroupTimers ?? settings.exportGroupTimers,
          exportIncludeDate: exportIncludeDate ?? settings.exportIncludeDate,
          exportIncludeProject:
              exportIncludeProject ?? settings.exportIncludeProject,
          exportIncludeDescription:
              exportIncludeDescription ?? settings.exportIncludeDescription,
          exportIncludeProjectDescription: exportIncludeProjectDescription ??
              settings.exportIncludeProjectDescription,
          exportIncludeStartTime:
              exportIncludeStartTime ?? settings.exportIncludeStartTime,
          exportIncludeEndTime:
              exportIncludeEndTime ?? settings.exportIncludeEndTime,
          exportIncludeDurationHours:
              exportIncludeDurationHours ?? settings.exportIncludeDurationHours,
          exportIncludeNotes: exportIncludeNotes ?? settings.exportIncludeNotes,
          groupTimers: groupTimers ?? settings.groupTimers,
          collapseDays: collapseDays ?? settings.collapseDays,
          autocompleteDescription:
              autocompleteDescription ?? settings.autocompleteDescription,
          defaultFilterStartDateToMonday: defaultFilterStartDateToMonday ??
              settings.defaultFilterStartDateToMonday,
          oneTimerAtATime: oneTimerAtATime ?? settings.oneTimerAtATime,
          showBadgeCounts: showBadgeCounts ?? settings.showBadgeCounts,
          defaultFilterDays: defaultFilterDays ?? settings.defaultFilterDays,
          hasAskedNotificationPermissions: hasAskedNotificationPermissions ??
              settings.hasAskedNotificationPermissions,
          showRunningTimersAsNotifications: showRunningTimersAsNotifications ??
              settings.showRunningTimersAsNotifications,
          showProjectNames: showProjectNames ?? settings.showProjectNames,
          nagAboutMissingTimer: nagAboutMissingTimer ?? settings.nagAboutMissingTimer,
        );

  @override
  List<Object> get props => [
        exportGroupTimers,
        exportIncludeDate,
        exportIncludeProject,
        exportIncludeDescription,
        exportIncludeProjectDescription,
        exportIncludeStartTime,
        exportIncludeEndTime,
        exportIncludeDurationHours,
        exportIncludeNotes,
        groupTimers,
        collapseDays,
        autocompleteDescription,
        defaultFilterStartDateToMonday,
        oneTimerAtATime,
        showBadgeCounts,
        defaultFilterDays,
        hasAskedNotificationPermissions,
        showRunningTimersAsNotifications,
        showProjectNames,
        nagAboutMissingTimer,
      ];
}
