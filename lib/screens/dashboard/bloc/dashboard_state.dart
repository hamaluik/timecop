part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String newDescription;
  final Project? newProject;
  final bool timerWasStarted;
  final DateTime? filterStart;
  final DateTime? filterEnd;
  final List<int?> hiddenProjects;
  final String? searchString;

  @override
  bool get stringify => true;

  const DashboardState(
      this.newDescription,
      this.newProject,
      this.timerWasStarted,
      this.filterStart,
      this.filterEnd,
      this.hiddenProjects,
      this.searchString);

  DashboardState.clone(
    DashboardState state,
    DateTime filterStart,
    DateTime filterEnd,
    String searchString, {
    String? newDescription,
    Project? newProject,
    bool? timerWasStarted,
    List<int>? hiddenProjects,
  }) : this(
            newDescription ?? state.newDescription,
            newProject ?? state.newProject,
            timerWasStarted ?? state.timerWasStarted,
            filterStart,
            filterEnd,
            hiddenProjects ?? state.hiddenProjects,
            searchString);

  @override
  List<Object?> get props => [
        newDescription,
        newProject,
        timerWasStarted,
        filterStart,
        filterEnd,
        hiddenProjects,
        searchString
      ];
}
