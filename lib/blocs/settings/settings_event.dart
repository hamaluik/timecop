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

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class LoadSettingsFromRepository extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SetDefaultProjectID extends SettingsEvent {
  final int projectID;

  const SetDefaultProjectID(this.projectID);

  @override
  List<Object> get props => [projectID];
}

class SetDefaultWorkTypeID extends SettingsEvent {
  final int workTypeID;

  const SetDefaultWorkTypeID(this.workTypeID);

  @override
  List<Object> get props => [workTypeID];
}

class SetBoolValueEvent extends SettingsEvent {
  final bool exportGroupTimers;
  final bool exportIncludeDateRangeInFilename;
  final bool exportIncludeTimeInFilename;
  final bool exportIncludeDate;
  final bool exportIncludeProject;
  final bool exportIncludeWorkType;
  final bool exportIncludeDescription;
  final bool exportIncludeProjectDescription;
  final bool exportIncludeStartTime;
  final bool exportIncludeEndTime;
  final bool exportIncludeDurationHours;
  final bool groupTimers;
  final bool collapseDays;
  final bool autocompleteDescription;
  final bool defaultFilterStartDateToMonday;
  final bool allowMultipleActiveTimers;
  final bool displayProjectNameInTimer;

  const SetBoolValueEvent(
      {this.exportGroupTimers,
      this.exportIncludeDateRangeInFilename,
      this.exportIncludeTimeInFilename,
      this.exportIncludeDate,
      this.exportIncludeProject,
      this.exportIncludeWorkType,
      this.exportIncludeDescription,
      this.exportIncludeProjectDescription,
      this.exportIncludeStartTime,
      this.exportIncludeEndTime,
      this.exportIncludeDurationHours,
      this.groupTimers,
      this.collapseDays,
      this.autocompleteDescription,
      this.defaultFilterStartDateToMonday,
      this.allowMultipleActiveTimers,
      this.displayProjectNameInTimer});

  @override
  List<Object> get props => [
        exportGroupTimers,
        exportIncludeDateRangeInFilename,
        exportIncludeTimeInFilename,
        exportIncludeDate,
        exportIncludeProject,
        exportIncludeWorkType,
        exportIncludeDescription,
        exportIncludeProjectDescription,
        exportIncludeStartTime,
        exportIncludeEndTime,
        exportIncludeDurationHours,
        groupTimers,
        collapseDays,
        autocompleteDescription,
        defaultFilterStartDateToMonday,
        allowMultipleActiveTimers,
        displayProjectNameInTimer
      ];
}
