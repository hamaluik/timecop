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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/projects/ProjectEditor.dart';
import 'package:timecop/models/project.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.projects),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (BuildContext context, SettingsState settingsState) =>
            BlocBuilder<ProjectsBloc, ProjectsState>(
                bloc: projectsBloc,
                builder: (BuildContext context, ProjectsState state) {
                  return ListView(
                    children: state.projects
                        .map((project) => Slidable(
                              startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.15,
                                  children: <Widget>[
                                    SlidableAction(
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      icon: FontAwesomeIcons.trash,
                                      onPressed: (_) async {
                                        bool delete = await (showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(L10N
                                                      .of(context)
                                                      .tr
                                                      .confirmDelete),
                                                  content: RichText(
                                                      textAlign:
                                                          TextAlign.justify,
                                                      text: TextSpan(
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .color),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: L10N
                                                                        .of(context)
                                                                        .tr
                                                                        .areYouSureYouWantToDelete +
                                                                    "\n\n"),
                                                            TextSpan(
                                                                text: "⬤ ",
                                                                style: TextStyle(
                                                                    color: project
                                                                        .colour)),
                                                            TextSpan(
                                                                text: project
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic)),
                                                          ])),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(L10N
                                                          .of(context)
                                                          .tr
                                                          .cancel),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                    ),
                                                    TextButton(
                                                      child: Text(L10N
                                                          .of(context)
                                                          .tr
                                                          .delete),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                    ),
                                                  ],
                                                )) as FutureOr<bool>);
                                        if (delete) {
                                          projectsBloc
                                              .add(DeleteProject(project));
                                        }
                                      },
                                    )
                                  ]),
                              endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.15,
                                  children: <Widget>[
                                    SlidableAction(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        icon: project.archived
                                            ? FontAwesomeIcons.boxOpen
                                            : FontAwesomeIcons.box,
                                        onPressed: (_) {
                                          projectsBloc.add(EditProject(
                                              Project.clone(project,
                                                  archived:
                                                      !project.archived)));
                                        })
                                  ]),
                              child: ListTile(
                                leading: ProjectColour(project: project),
                                title: Text(project.name),
                                trailing: project.archived
                                    ? Icon(FontAwesomeIcons.box)
                                    : null,
                                onTap: () => showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ProjectEditor(
                                          project: project,
                                        )),
                              ),
                            ))
                        .toList(),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("addProject"),
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
            builder: (BuildContext context) => ProjectEditor(
                  project: null,
                )),
      ),
    );
  }
}
