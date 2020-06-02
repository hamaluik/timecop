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

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/models/project.dart';
import './bloc.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final DataProvider data;
  ProjectsBloc(this.data);

  @override
  ProjectsState get initialState => ProjectsState.initial();

  @override
  Stream<ProjectsState> mapEventToState(
    ProjectsEvent event,
  ) async* {
    if (event is LoadProjects) {
      List<Project> projects = await data.listProjects();
      yield ProjectsState(projects);
    } else if (event is CreateProject) {
      Project newProject =
          await data.createProject(name: event.name, colour: event.colour);
      List<Project> projects =
          state.projects.map((project) => Project.clone(project)).toList();
      projects.add(newProject);
      projects.sort((a, b) => a.name.compareTo(b.name));
      yield ProjectsState(projects);
    } else if (event is EditProject) {
      await data.editProject(event.project);
      List<Project> projects = state.projects.map((project) {
        if (project.id == event.project.id) return Project.clone(event.project);
        return Project.clone(project);
      }).toList();
      projects.sort((a, b) => a.name.compareTo(b.name));
      yield ProjectsState(projects);
    } else if (event is DeleteProject) {
      await data.deleteProject(event.project);
      List<Project> projects = state.projects
          .where((p) => p.id != event.project.id)
          .map((p) => Project.clone(p))
          .toList();
      yield ProjectsState(projects);
    }
  }

  Project getProjectByID(int id) {
    if (id == null) return null;
    for (Project p in state.projects) {
      if (p.id == id) return p;
    }
    return null;
  }
}
