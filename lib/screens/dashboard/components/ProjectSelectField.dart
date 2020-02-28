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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class ProjectSelectField extends StatefulWidget {
  ProjectSelectField({Key key}) : super(key: key);

  @override
  _ProjectSelectFieldState createState() => _ProjectSelectFieldState();
}

class _ProjectSelectFieldState extends State<ProjectSelectField> {
  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    assert(bloc != null);
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    assert(projectsBloc != null);
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (BuildContext context, ProjectsState projectsState) {
        return BlocBuilder<DashboardBloc, DashboardState>(
          bloc: bloc,
          builder: (BuildContext context, DashboardState state) {
            // detect if the project we had selected was deleted
            if(state.newProject != null && projectsBloc.getProjectByID(state.newProject.id) == null) {
              bloc.add(ProjectChangedEvent(null));
              return DropdownButton(
                value: bloc.state.newProject,
                underline: Container(),
                elevation: 0,
                onChanged: (Project newProject) {
                  bloc.add(ProjectChangedEvent(newProject));
                },
                items: <DropdownMenuItem<Project>>[
                  DropdownMenuItem<Project>(
                    child: Row(
                      children: <Widget>[
                        ProjectColour(project: null),
                        Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                          child: Text(TimeCopLocalizations.of(context).noProject, style: TextStyle(color: Theme.of(context).disabledColor)),
                        ),
                      ],
                    ),
                    value: null,
                  )
                ],
              );
            }

            return DropdownButton(
              value: bloc.state.newProject,
              underline: Container(),
              elevation: 0,
              onChanged: (Project newProject) {
                bloc.add(ProjectChangedEvent(newProject));
              },
              items: <DropdownMenuItem<Project>>[
                DropdownMenuItem<Project>(
                  child: Row(
                    children: <Widget>[
                      ProjectColour(project: null),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                        child: Text(TimeCopLocalizations.of(context).noProject, style: TextStyle(color: Theme.of(context).disabledColor)),
                      ),
                    ],
                  ),
                  value: null,
                )
              ].followedBy(projectsState.projects.map(
                (Project project) => DropdownMenuItem<Project>(
                  child: Row(
                    children: <Widget>[
                      ProjectColour(project: project,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                        child: Text(project.name),
                      ),
                    ],
                  ),
                  value: project,
                )
              )).toList(),
            );
          },
        );
      }
    );
  }
}