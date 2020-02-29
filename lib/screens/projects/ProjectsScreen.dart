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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/projects/ProjectEditor.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    assert(projectsBloc != null);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.projects),
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        bloc: projectsBloc,
        builder: (BuildContext context, ProjectsState state) {
          return ListView(
            children: state.projects.map((project) => Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: ListTile(
                leading: ProjectColour(project: project),
                title: Text(project.name),
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => ProjectEditor(project: project,)
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  color: Theme.of(context).errorColor,
                  foregroundColor: Theme.of(context).accentIconTheme.color,
                  icon: FontAwesomeIcons.trash,
                  onTap: () async {
                    bool delete = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(L10N.of(context).tr.confirmDelete),
                        content: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(color: Theme.of(context).textTheme.body1.color),
                            children: <TextSpan>[
                              TextSpan(text: L10N.of(context).tr.areYouSureYouWantToDeletePrefix),
                              TextSpan(text: "⬤ ", style: TextStyle(color: project.colour)),
                              TextSpan(text: project.name, style: TextStyle(fontStyle: FontStyle.italic)),
                              TextSpan(text: L10N.of(context).tr.areYouSureYouWantToDeletePostfix),
                            ]
                          )
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(L10N.of(context).tr.cancel),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                            child: Text(L10N.of(context).tr.delete),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      )
                    );
                    if(delete) {
                      projectsBloc.add(DeleteProject(project));
                    }
                  },
                )
              ],
            )).toList(),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Stack(
          // shenanigans to properly centre the icon (font awesome glyphs are variable
          // width but the library currently doesn't deal with that)
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 15,
              left: 16,
              child: Icon(FontAwesomeIcons.plus),
            )
          ],
        ),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) => ProjectEditor(project: null,)
        ),
      ),
    );
  }
}