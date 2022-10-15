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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/models/project.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ProjectsBloc projectsBloc;
  final SettingsBloc settingsBloc;

  DashboardBloc(this.projectsBloc, this.settingsBloc)
      : super(DashboardState("", projectsBloc.getProjectByID(-1), false,
            settingsBloc.getFilterStartDate(), null, const <int>[], null)) {
    on<DescriptionChangedEvent>((event, emit) {
      emit(DashboardState(
          event.description!,
          state.newProject,
          false,
          state.filterStart,
          state.filterEnd,
          state.hiddenProjects,
          state.searchString));
    });

    on<ProjectChangedEvent>((event, emit) {
      emit(DashboardState(
          state.newDescription,
          event.project,
          false,
          state.filterStart,
          state.filterEnd,
          state.hiddenProjects,
          state.searchString));
    });

    on<TimerWasStartedEvent>((event, emit) {
      Project? newProject = projectsBloc.getProjectByID(-1);
      emit(DashboardState("", newProject, true, state.filterStart,
          state.filterEnd, state.hiddenProjects, state.searchString));
    });

    on<ResetEvent>((event, emit) {
      Project? newProject = projectsBloc.getProjectByID(-1);
      emit(DashboardState("", newProject, false, state.filterStart,
          state.filterEnd, state.hiddenProjects, state.searchString));
    });

    on<FilterStartChangedEvent>((event, emit) {
      final filterStart = event.filterStart;
      DateTime? end = state.filterEnd;
      if (end != null && filterStart != null && filterStart.isAfter(end)) {
        end = filterStart.add(const Duration(
            hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
      }

      emit(DashboardState(state.newDescription, state.newProject, false,
          event.filterStart, end, state.hiddenProjects, state.searchString));
    });

    on<FilterEndChangedEvent>((event, emit) {
      emit(DashboardState(
          state.newDescription,
          state.newProject,
          false,
          state.filterStart,
          event.filterEnd,
          state.hiddenProjects,
          state.searchString));
    });

    on<FilterProjectsChangedEvent>((event, emit) {
      emit(DashboardState(
          state.newDescription,
          state.newProject,
          false,
          state.filterStart,
          state.filterEnd,
          event.projects,
          state.searchString));
    });

    on<SearchChangedEvent>((event, emit) {
      emit(DashboardState(
          state.newDescription,
          state.newProject,
          false,
          state.filterStart,
          state.filterEnd,
          state.hiddenProjects,
          event.search));
    });
  }
}
