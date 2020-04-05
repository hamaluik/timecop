import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'startendtimes_event.dart';
part 'startendtimes_state.dart';

class StartEndTimesBloc extends Bloc<StartEndTimesEvent, StartEndTimesState> {
  @override
  StartEndTimesState get initialState => NormalStartEndTimesState(null, null);

  @override
  Stream<StartEndTimesState> mapEventToState(
    StartEndTimesEvent event,
  ) async* {
    if(event is StartEditingTimeEvent) {
      yield EditingStartEndTimesState(state.start, state.end, state.start, state.end);
    }
    else if(event is SetStartTimeEvent) {
      if(state is EditingStartEndTimesState) {
        EditingStartEndTimesState s = state as EditingStartEndTimesState;
        // adjust the end time to keep a constant duration if we would somehow make the time negative
        DateTime end = s.end;
        if(s.oldEnd != null && event.time.isAfter(s.oldStart)) {
          Duration d = s.oldEnd.difference(s.oldStart);
          end = event.time.add(d);
        }
        yield(EditingStartEndTimesState(event.time, end, s.oldStart, s.oldEnd));
      }
      else if(state is NormalStartEndTimesState) {
        yield(NormalStartEndTimesState(state.start, event.time));
      }
      else {
        assert(false);
      }
    }
    else if(event is SetEndTimeEvent) {
      if(state is EditingStartEndTimesState) {
        EditingStartEndTimesState s = state as EditingStartEndTimesState;
        yield(EditingStartEndTimesState(s.start, event.time, s.oldStart, s.oldEnd));
      }
      else if(state is NormalStartEndTimesState) {
        yield(NormalStartEndTimesState(state.start, event.time));
      }
      else {
        assert(false);
      }
    }
    else if(event is SaveTimeEvent) {
      yield NormalStartEndTimesState(state.start, state.end);
    }
    else if(event is CancelSetTimeEvent) {
      if(state is EditingStartEndTimesState) {
        EditingStartEndTimesState s = state as EditingStartEndTimesState;
        yield(NormalStartEndTimesState(s.oldStart, s.oldEnd));
      }
      else if(state is NormalStartEndTimesState) {
        yield(NormalStartEndTimesState(state.start, state.end));
      }
      else {
        assert(false);
      }
    }
  }
}
