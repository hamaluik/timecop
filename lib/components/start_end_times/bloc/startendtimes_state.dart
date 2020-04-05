part of 'startendtimes_bloc.dart';

abstract class StartEndTimesState extends Equatable {
  final DateTime start;
  final DateTime end;

  const StartEndTimesState(this.start, this.end);
}

class NormalStartEndTimesState extends StartEndTimesState {
  NormalStartEndTimesState(DateTime start, DateTime end) : super(start, end);

  @override List<Object> get props => [start, end];
}

class EditingStartEndTimesState extends StartEndTimesState {
  final DateTime oldStart;
  final DateTime oldEnd;

  EditingStartEndTimesState(DateTime start, DateTime end, this.oldStart, this.oldEnd)
    : super(start, end);

  @override List<Object> get props => [start, end, oldStart, oldEnd];
}
