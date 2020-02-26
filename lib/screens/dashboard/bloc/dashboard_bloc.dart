import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timecop/models/project.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  @override
  DashboardState get initialState => DashboardState("", null);

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if(event is DescriptionChangedEvent) {
      yield DashboardState(event.description, state.newProject);
    }
    else if(event is ProjectChangedEvent) {
      yield DashboardState(state.newDescription, event.project);
    }
  }
}
