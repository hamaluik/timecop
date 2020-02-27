part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String newDescription;
  final Project newProject;
  final bool timerWasStarted;

  const DashboardState(this.newDescription, this.newProject, this.timerWasStarted)
    : assert(newDescription != null),
      assert(timerWasStarted != null);

  @override
  List<Object> get props => [newDescription, newProject, timerWasStarted];
}
