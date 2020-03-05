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
  final bool exportIncludeStartTime;
  final bool exportIncludeEndTime;
  final bool exportIncludeDurationHours;
  final int defaultProjectID;

  SettingsState({
    @required this.exportGroupTimers,
    @required this.exportIncludeDate,
    @required this.exportIncludeProject,
    @required this.exportIncludeDescription,
    @required this.exportIncludeStartTime,
    @required this.exportIncludeEndTime,
    @required this.exportIncludeDurationHours,
    @required this.defaultProjectID,
  })  : assert(exportGroupTimers != null),
        assert(exportIncludeDate != null),
        assert(exportIncludeProject != null),
        assert(exportIncludeDescription != null),
        assert(exportIncludeStartTime != null),
        assert(exportIncludeEndTime != null),
        assert(exportIncludeDurationHours != null),
        assert(defaultProjectID != null);

  static SettingsState initial() {
    return SettingsState(
      exportGroupTimers: true,
      exportIncludeDate: true,
      exportIncludeProject: true,
      exportIncludeDescription: true,
      exportIncludeStartTime: false,
      exportIncludeEndTime: false,
      exportIncludeDurationHours: true,
      defaultProjectID: -1,
    );
  }

  SettingsState.clone(SettingsState project,
      {bool exportGroupTimers,
      bool exportIncludeDate,
      bool exportIncludeProject,
      bool exportIncludeDescription,
      bool exportIncludeStartTime,
      bool exportIncludeEndTime,
      bool exportIncludeDurationHours,
      int defaultProjectID})
      : this(
          exportGroupTimers: exportGroupTimers ?? project.exportGroupTimers,
          exportIncludeDate:
              exportIncludeDate ?? project.exportIncludeDate,
          exportIncludeProject:
              exportIncludeProject ?? project.exportIncludeProject,
          exportIncludeDescription:
              exportIncludeDescription ?? project.exportIncludeDescription,
          exportIncludeStartTime:
              exportIncludeStartTime ?? project.exportIncludeStartTime,
          exportIncludeEndTime:
              exportIncludeEndTime ?? project.exportIncludeEndTime,
          exportIncludeDurationHours:
              exportIncludeDurationHours ?? project.exportIncludeDurationHours,
          defaultProjectID:
              defaultProjectID ?? project.defaultProjectID,
        );

  @override
  List<Object> get props => [
        exportGroupTimers,
        exportIncludeDate,
        exportIncludeProject,
        exportIncludeDescription,
        exportIncludeStartTime,
        exportIncludeEndTime,
        exportIncludeDurationHours,
        defaultProjectID,
      ];
}
