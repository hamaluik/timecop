part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String newDescription;
  final Project newProject;

  const DashboardState(this.newDescription, this.newProject)
    : assert(newDescription != null);

  @override
  List<Object> get props => [newDescription, newProject];
}
