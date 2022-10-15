// Copyright 2020 Kenton Hamaluik
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
