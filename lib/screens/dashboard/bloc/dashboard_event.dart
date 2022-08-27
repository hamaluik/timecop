part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class DescriptionChangedEvent extends DashboardEvent {
  final String? description;
  const DescriptionChangedEvent(this.description);
  @override
  List<Object?> get props => [description];
}

class ProjectChangedEvent extends DashboardEvent {
  final Project? project;
  const ProjectChangedEvent(this.project);
  @override
  List<Object?> get props => [project];
}

class ResetEvent extends DashboardEvent {
  const ResetEvent();
  @override
  List<Object> get props => [];
}

class TimerWasStartedEvent extends DashboardEvent {
  const TimerWasStartedEvent();
  @override
  List<Object> get props => [];
}

class FilterStartChangedEvent extends DashboardEvent {
  final DateTime? filterStart;
  const FilterStartChangedEvent(this.filterStart);
  @override
  List<Object?> get props => [filterStart];
}

class FilterEndChangedEvent extends DashboardEvent {
  final DateTime? filterEnd;
  const FilterEndChangedEvent(this.filterEnd);
  @override
  List<Object?> get props => [filterEnd];
}

class FilterProjectsChangedEvent extends DashboardEvent {
  final List<int?> projects;
  const FilterProjectsChangedEvent(this.projects);
  @override
  List<Object> get props => [projects];
}

class SearchChangedEvent extends DashboardEvent {
  final String? search;
  const SearchChangedEvent(this.search);
  @override
  List<Object?> get props => [search];
}
