import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      Project newProject = projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
    return DashboardState("", newProject, false);
  }

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if(event is DescriptionChangedEvent) {
      yield DashboardState(event.description, state.newProject, false);
    }
    else if(event is ProjectChangedEvent) {
      yield DashboardState(state.newDescription, event.project, false);
    }
    else if(event is TimerWasStartedEvent) {
      Project newProject = projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
      yield DashboardState("", newProject, true);
    }
    else if(event is ResetEvent) {
      Project newProject = projectsBloc.getProjectByID(settingsBloc.state.defaultProjectID);
      yield DashboardState("", newProject, false);
    }
  }
}
