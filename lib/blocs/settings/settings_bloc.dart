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
import 'package:timecop/data_providers/settings_provider.dart';
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
    if(event is LoadSettingsFromRepository) {
      bool exportGroupTimers = await settings.getBool("exportGroupTimers") ?? state.exportGroupTimers;
      bool exportIncludeProject = await settings.getBool("exportIncludeProject") ?? state.exportIncludeProject;
      bool exportIncludeDescription = await settings.getBool("exportIncludeDescription") ?? state.exportIncludeDescription;
      bool exportIncludeStartTime = await settings.getBool("exportIncludeStartTime") ?? state.exportIncludeStartTime;
      bool exportIncludeEndTime = await settings.getBool("exportIncludeEndTime") ?? state.exportIncludeEndTime;
      bool exportIncludeDurationHours = await settings.getBool("exportIncludeDurationHours") ?? state.exportIncludeDurationHours;
      int defaultProjectID = await settings.getInt("defaultProjectID") ?? state.defaultProjectID;
      yield SettingsState(
        exportGroupTimers: exportGroupTimers,
        exportIncludeProject: exportIncludeProject,
        exportIncludeDescription: exportIncludeDescription,
        exportIncludeStartTime: exportIncludeStartTime,
        exportIncludeEndTime: exportIncludeEndTime,
        exportIncludeDurationHours: exportIncludeDurationHours,
        defaultProjectID: defaultProjectID,
      );
    }
    else if(event is SetExportGroupTimers) {
      await settings.setBool("exportGroupTimers", event.value);
      yield SettingsState.clone(state, exportGroupTimers: event.value);
    }
    else if(event is SetExportIncludeProject) {
      await settings.setBool("exportIncludeProject", event.value);
      yield SettingsState.clone(state, exportIncludeProject: event.value);
    }
    else if(event is SetExportIncludeDescription) {
      await settings.setBool("exportIncludeDescription", event.value);
      yield SettingsState.clone(state, exportIncludeDescription: event.value);
    }
    else if(event is SetExportIncludeStartTime) {
      await settings.setBool("exportIncludeStartTime", event.value);
      yield SettingsState.clone(state, exportIncludeStartTime: event.value);
    }
    else if(event is SetExportIncludeEndTime) {
      await settings.setBool("exportIncludeEndTime", event.value);
      yield SettingsState.clone(state, exportIncludeEndTime: event.value);
    }
    else if(event is SetExportIncludeDurationHours) {
      await settings.setBool("exportIncludeDurationHours", event.value);
      yield SettingsState.clone(state, exportIncludeDurationHours: event.value);
    }
    else if(event is SetDefaultProjectID) {
      await settings.setInt("defaultProjectID", event.projectID ?? -1);
      yield SettingsState.clone(state, defaultProjectID: event.projectID ?? -1);
    }
  }
}
