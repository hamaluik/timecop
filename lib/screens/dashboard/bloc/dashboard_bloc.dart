import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timecop/models/project.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  @override
  DashboardState get initialState => DashboardState("", null, false);

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
      yield DashboardState("", null, true);
    }
    else if(event is ResetEvent) {
      yield DashboardState("", null, false);
    }
  }
}
