part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String newDescription;
  final Project newProject;
  final bool timerWasStarted;
  final DateTime filterStart;
  final DateTime filterEnd;
  final List<int> filterProjects;
  final String searchString;

  @override
  bool get stringify => true;

  const DashboardState(
      this.newDescription,
      this.newProject,
      this.timerWasStarted,
      this.filterStart,
      this.filterEnd,
      this.filterProjects,
      this.searchString)
      : assert(newDescription != null),
        assert(timerWasStarted != null),
        assert(filterProjects != null);

  DashboardState.clone(
    DashboardState state,
    DateTime filterStart,
    DateTime filterEnd,
    String searchString,
  {
    String newDescription,
    Project newProject,
    bool timerWasStarted,
    List<int> filterProjects,
  })
    : this(
        newDescription ?? state.newDescription,
        newProject ?? state.newProject,
        timerWasStarted ?? state.timerWasStarted,
        filterStart,
        filterEnd,
        filterProjects ?? state.filterProjects,
        searchString
      );

  @override
  List<Object> get props => [newDescription, newProject, timerWasStarted, filterStart, filterEnd, filterProjects, searchString];
}
