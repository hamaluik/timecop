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

enum _ProjectMenuItems { archive, delete }

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

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
                                          Theme.of(context).colorScheme.error,
                                      foregroundColor:
                                          Theme.of(context).colorScheme.onError,
                                      icon: FontAwesomeIcons.trash,
                                      onPressed: (_) async {
                                        await _deleteProject(
                                            context, projectsBloc, project);
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
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        icon: project.archived
                                            ? FontAwesomeIcons.boxOpen
                                            : FontAwesomeIcons.boxArchive,
                                        onPressed: (_) {
                                          projectsBloc.add(EditProject(
                                              Project.clone(project,
                                                  archived:
                                                      !project.archived)));
                                        })
                                  ]),
                              child: ListTile(
                                leading: ProjectColour(project: project),
                                title: project.archived
                                    ? Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.boxArchive,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(project.name))
                                        ],
                                      )
                                    : Text(project.name),
                                trailing: PopupMenuButton<_ProjectMenuItems>(
                                    onSelected: (menuItem) async {
                                      switch (menuItem) {
                                        case _ProjectMenuItems.archive:
                                          projectsBloc.add(EditProject(
                                              Project.clone(project,
                                                  archived:
                                                      !project.archived)));
                                          break;
                                        case _ProjectMenuItems.delete:
                                          await _deleteProject(
                                              context, projectsBloc, project);
                                          break;
                                      }
                                    },
                                    itemBuilder: (_) => [
                                          PopupMenuItem(
                                            value: _ProjectMenuItems.archive,
                                            child: Text(project.archived
                                                ? L10N.of(context).tr.unarchive
                                                : L10N.of(context).tr.archive),
                                          ),
                                          PopupMenuItem(
                                            value: _ProjectMenuItems.delete,
                                            child: Text(
                                                L10N.of(context).tr.delete),
                                          )
                                        ]),
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
        tooltip: L10N.of(context).tr.createNewProject,
        key: const Key("addProject"),
        child: const Stack(
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
            builder: (BuildContext context) => const ProjectEditor(
                  project: null,
                )),
      ),
    );
  }

  Future<void> _deleteProject(
      BuildContext context, ProjectsBloc projectsBloc, Project project) async {
    bool delete = await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              final theme = Theme.of(context);
              return AlertDialog(
                title: Text(L10N.of(context).tr.confirmDelete),
                content: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "${L10N.of(context).tr.areYouSureYouWantToDelete}\n\n"),
                          TextSpan(
                              text: "⬤ ",
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: project.colour)),
                          TextSpan(
                              text: project.name,
                              style: theme.textTheme.bodyMedium),
                        ])),
                actions: <Widget>[
                  TextButton(
                    child: Text(L10N.of(context).tr.cancel),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: Text(L10N.of(context).tr.delete),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            })) ??
        false;
    if (delete) {
      projectsBloc.add(DeleteProject(project));
    }
  }
}
