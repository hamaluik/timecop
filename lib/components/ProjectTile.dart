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
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';

class ProjectTile extends StatelessWidget {
  final Iterable<Project> projects;
  final Function(Project? project) isEnabled;
  final Function(Project? project) onToggled;
  final Function() onAllSelected;
  final Function() onNoneSelected;

  const ProjectTile(
      {super.key,
      required this.projects,
      required this.isEnabled,
      required this.onToggled,
      required this.onAllSelected,
      required this.onNoneSelected});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(L10N.of(context).tr.projects,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700)),
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ElevatedButton(
              onPressed: onNoneSelected,
              child: Text(L10N.of(context).tr.selectNone),
            ),
            ElevatedButton(
              onPressed: onAllSelected,
              child: Text(L10N.of(context).tr.selectAll),
            ),
          ],
        ),
      ]
          .followedBy(<Project?>[null]
              .followedBy(projects)
              .map((project) => CheckboxListTile(
                    secondary: ProjectColour(
                      project: project,
                    ),
                    title: Text(project?.name ?? L10N.of(context).tr.noProject),
                    value: isEnabled(project),
                    onChanged: (_) => onToggled(project),
                  )))
          .toList(),
    );
  }
}
