import 'dart:async';

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

  DashboardBloc(this.projectsBloc, this.settingsBloc);

  @override
  DashboardState get initialState {
    Project newProject =
        projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
    return DashboardState("", newProject, false,
        settingsBloc.getFilterStartDate(), null, <int>[], null);
  }

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is DescriptionChangedEvent) {
      yield DashboardState(
          event.description,
          state.newProject,
          false,
          state.filterStart,
          state.filterEnd,
          state.hiddenProjects,
          state.searchString);
    } else if (event is ProjectChangedEvent) {
      yield DashboardState(
          state.newDescription,
          event.project,
          false,
          state.filterStart,
          state.filterEnd,
          state.hiddenProjects,
          state.searchString);
    } else if (event is TimerWasStartedEvent) {
      Project newProject =
          projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
      yield DashboardState("", newProject, true, state.filterStart,
          state.filterEnd, state.hiddenProjects, state.searchString);
    } else if (event is ResetEvent) {
      Project newProject =
          projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
      yield DashboardState("", newProject, false, state.filterStart,
          state.filterEnd, state.hiddenProjects, state.searchString);
    } else if (event is FilterStartChangedEvent) {
      DateTime end = state.filterEnd;
      if (state.filterEnd != null &&
          event.filterStart.isAfter(state.filterEnd)) {
        end = event.filterStart.add(
            Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
      }

      yield DashboardState(state.newDescription, state.newProject, false,
          event.filterStart, end, state.hiddenProjects, state.searchString);
    } else if (event is FilterEndChangedEvent) {
      yield DashboardState(
          state.newDescription,
          state.newProject,
          false,
          state.filterStart,
          event.filterEnd,
          state.hiddenProjects,
          state.searchString);
    } else if (event is FilterProjectsChangedEvent) {
      yield DashboardState(
          state.newDescription,
          state.newProject,
          false,
          state.filterStart,
          state.filterEnd,
          event.projects,
          state.searchString);
    } else if (event is SearchChangedEvent) {
      yield DashboardState(
          state.newDescription,
          state.newProject,
          false,
          state.filterStart,
          state.filterEnd,
          state.hiddenProjects,
          event.search);
    }
  }
}
