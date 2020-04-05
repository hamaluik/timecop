part of 'startendtimes_bloc.dart';

abstract class StartEndTimesEvent extends Equatable {
  const StartEndTimesEvent();
}

class StartEditingTimeEvent extends StartEndTimesEvent {
  @override List<Object> get props => [];
}

class SetStartTimeEvent extends StartEndTimesEvent {
  final DateTime time;
  SetStartTimeEvent(this.time);
  @override List<Object> get props => [time];
}

class SetEndTimeEvent extends StartEndTimesEvent {
  final DateTime time;
  SetEndTimeEvent(this.time);
  @override List<Object> get props => [time];
}

class SaveTimeEvent extends StartEndTimesEvent {
  @override List<Object> get props => [];
}

class CancelSetTimeEvent extends StartEndTimesEvent {
  @override List<Object> get props => [];
}
