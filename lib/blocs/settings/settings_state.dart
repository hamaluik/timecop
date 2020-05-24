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
import 'package:flutter/foundation.dart';

class SettingsState extends Equatable {
  final bool exportGroupTimers;
  final bool exportIncludeDate;
  final bool exportIncludeProject;
  final bool exportIncludeDescription;
  final bool exportIncludeProjectDescription;
  final bool exportIncludeStartTime;
  final bool exportIncludeEndTime;
  final bool exportIncludeDurationHours;
  final int defaultProjectID;
  final bool groupTimers;
  final bool collapseDays;
  final bool autocompleteDescription;
  final bool defaultFilterStartDateToMonday;
  final bool allowMultipleActiveTimers;

  SettingsState({
    @required this.exportGroupTimers,
    @required this.exportIncludeDate,
    @required this.exportIncludeProject,
    @required this.exportIncludeDescription,
    @required this.exportIncludeProjectDescription,
    @required this.exportIncludeStartTime,
    @required this.exportIncludeEndTime,
    @required this.exportIncludeDurationHours,
    @required this.defaultProjectID,
    @required this.groupTimers,
    @required this.collapseDays,
    @required this.autocompleteDescription,
    @required this.defaultFilterStartDateToMonday,
    @required this.allowMultipleActiveTimers,
  })  : assert(exportGroupTimers != null),
        assert(exportIncludeDate != null),
        assert(exportIncludeProject != null),
        assert(exportIncludeDescription != null),
        assert(exportIncludeProjectDescription != null),
        assert(exportIncludeStartTime != null),
        assert(exportIncludeEndTime != null),
        assert(exportIncludeDurationHours != null),
        assert(defaultProjectID != null),
        assert(groupTimers != null),
        assert(collapseDays != null),
        assert(autocompleteDescription != null),
        assert(defaultFilterStartDateToMonday != null),
        assert(allowMultipleActiveTimers != null);

  static SettingsState initial() {
    return SettingsState(
      exportGroupTimers: true,
      exportIncludeDate: true,
      exportIncludeProject: true,
      exportIncludeDescription: true,
      exportIncludeProjectDescription: false,
      exportIncludeStartTime: false,
      exportIncludeEndTime: false,
      exportIncludeDurationHours: true,
      defaultProjectID: -1,
      groupTimers: true,
      collapseDays: false,
      autocompleteDescription: true,
      defaultFilterStartDateToMonday: true,
      allowMultipleActiveTimers: true,
    );
  }

  SettingsState.clone(
    SettingsState project, {
    bool exportGroupTimers,
    bool exportIncludeDate,
    bool exportIncludeProject,
    bool exportIncludeDescription,
    bool exportIncludeProjectDescription,
    bool exportIncludeStartTime,
    bool exportIncludeEndTime,
    bool exportIncludeDurationHours,
    int defaultProjectID,
    bool groupTimers,
    bool collapseDays,
    bool autocompleteDescription,
    bool defaultFilterStartDateToMonday,
    bool allowMultipleActiveTimers,
  }) : this(
          exportGroupTimers: exportGroupTimers ?? project.exportGroupTimers,
          exportIncludeDate: exportIncludeDate ?? project.exportIncludeDate,
          exportIncludeProject: exportIncludeProject ?? project.exportIncludeProject,
          exportIncludeDescription: exportIncludeDescription ?? project.exportIncludeDescription,
          exportIncludeProjectDescription: exportIncludeProjectDescription ?? project.exportIncludeProjectDescription,
          exportIncludeStartTime: exportIncludeStartTime ?? project.exportIncludeStartTime,
          exportIncludeEndTime: exportIncludeEndTime ?? project.exportIncludeEndTime,
          exportIncludeDurationHours: exportIncludeDurationHours ?? project.exportIncludeDurationHours,
          defaultProjectID: defaultProjectID ?? project.defaultProjectID,
          groupTimers: groupTimers ?? project.groupTimers,
          collapseDays: collapseDays ?? project.collapseDays,
          autocompleteDescription: autocompleteDescription ?? project.autocompleteDescription,
          defaultFilterStartDateToMonday: defaultFilterStartDateToMonday ?? project.defaultFilterStartDateToMonday,
          allowMultipleActiveTimers: allowMultipleActiveTimers ?? project.allowMultipleActiveTimers,
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
        defaultProjectID,
        groupTimers,
        collapseDays,
        autocompleteDescription,
        defaultFilterStartDateToMonday,
        allowMultipleActiveTimers,
      ];
}
