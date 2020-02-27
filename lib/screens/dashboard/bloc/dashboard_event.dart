part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class DescriptionChangedEvent extends DashboardEvent {
  final String description;
  const DescriptionChangedEvent(this.description);

  @override List<Object> get props => [description];
}

class ProjectChangedEvent extends DashboardEvent {
  final Project project;
  const ProjectChangedEvent(this.project);

  @override List<Object> get props => [project];
}

class ResetFieldsEvent extends DashboardEvent {
  const ResetFieldsEvent();

  @override List<Object> get props => [];
}