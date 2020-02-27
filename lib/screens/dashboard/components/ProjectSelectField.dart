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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/blocs/projects/bloc.dart';
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
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (BuildContext context, ProjectsState projectsState) => BlocBuilder<DashboardBloc, DashboardState>(
        builder: (BuildContext context, DashboardState state) => DropdownButton(
          onChanged: (Project newProject) {
            final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
            bloc.add(ProjectChangedEvent(newProject));
          },
          items: <DropdownMenuItem<Project>>[
            DropdownMenuItem<Project>(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.circle, size: 16),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                    child: Text("(no project)"),
                  ),
                ],
              ),
              value: null,
            )
          ].followedBy(projectsState.projects.map(
            (Project project) => DropdownMenuItem<Project>(
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.solidCircle, size: 16, color: project.colour,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                    child: Text(project.name),
                  ),
                ],
              ),
              value: project,
            )
          )).toList(),
        ),
      )
    );
  }
}