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
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class LoadSettingsFromRepository extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class ImportDatabaseEvent extends SettingsEvent {
  final String path;
  final TimersBloc timers;
  final ProjectsBloc projects;
  const ImportDatabaseEvent(this.path, this.timers, this.projects)
      : assert(path != null),
        assert(timers != null),
        assert(projects != null);
  @override
  List<Object> get props => [path, timers, projects];
}

class SetBoolValueEvent extends SettingsEvent {
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
  final bool showRunningTimersAsNotifications;

  const SetBoolValueEvent(
      {this.exportGroupTimers,
      this.exportIncludeDate,
      this.exportIncludeProject,
      this.exportIncludeDescription,
      this.exportIncludeProjectDescription,
      this.exportIncludeStartTime,
      this.exportIncludeEndTime,
      this.exportIncludeDurationHours,
      this.exportIncludeNotes,
      this.groupTimers,
      this.collapseDays,
      this.autocompleteDescription,
      this.defaultFilterStartDateToMonday,
      this.oneTimerAtATime,
      this.showBadgeCounts,
      this.showRunningTimersAsNotifications});

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
        showRunningTimersAsNotifications,
      ];
}

class SetDefaultFilterDays extends SettingsEvent {
  final int days;
  const SetDefaultFilterDays(this.days);
  @override
  List<Object> get props => [days];
}
