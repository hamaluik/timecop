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
import 'package:timecop/themes.dart';

class ProjectTag extends StatelessWidget {
  final Project? project;

  const ProjectTag({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ProjectColour(mini: true, project: project),
      const SizedBox(width: 6),
      Text(
        project?.name ?? L10N.of(context).tr.noProject,
        style: theme.textTheme.bodyMedium?.copyWith(
            color: project == null
                ? ThemeUtil.getOnBackgroundLighter(context)
                : theme.colorScheme.onSurface),
      )
    ]);
  }
}
