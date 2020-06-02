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
import 'package:timecop/models/project.dart';

class ProjectColour extends StatelessWidget {
  static const double SIZE = 22;
  final Project project;
  final bool mini;
  const ProjectColour({Key key, this.project, this.mini}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool m = mini ?? false;
    double scale = m ? 0.75 : 1.0;

    return Container(
      key: Key("pc-${project?.id}-m"),
      width: SIZE * scale,
      height: SIZE * scale,
      decoration: BoxDecoration(
        color: project?.colour ?? Colors.transparent,
        //borderRadius: BorderRadius.circular(SIZE * 0.5 * scale),
        border: project == null
            ? Border.all(
                color: Theme.of(context).disabledColor,
                width: 3.0,
              )
            : null,
        shape: BoxShape.circle,
      ),
    );
  }
}
