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

class Legend extends StatelessWidget {
  final Iterable<Project> projects;

  const Legend({Key key, @required this.projects})
      : assert(projects != null),
        super(key: key);

  List<Widget> _chips(BuildContext context) {
    return projects
        .map((project) => Chip(
              avatar: ProjectColour(project: project, mini: true),
              label: Text(project?.name ?? L10N.of(context).tr.noProject,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.body1.fontSize * 0.75,
                  )),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (projects.length <= 5) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 4.0,
        children: _chips(context),
      );
    }
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: _chips(context),
      ),
    );
  }
}
