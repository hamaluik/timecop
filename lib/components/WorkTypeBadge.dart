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

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:timecop/models/WorkType.dart';

class WorkTypeBadge extends StatelessWidget {
  static const double SIZE = 22;
  final bool mini = false;
  final WorkType workType;

  const WorkTypeBadge({Key key, this.workType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool m = mini ?? false;
    double scale = m ? 0.75 : 1.0;

    return workType == null
        ? Container(
            key: Key("wtc-${workType?.id}-m"),
            width: SIZE * scale * 1.5,
            height: SIZE * scale,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(SIZE * 0.5 * scale),
              border: Border.all(
                color: Theme.of(context).disabledColor,
                width: 3.0,
              ),
              shape: BoxShape.rectangle,
            ),
          )
        : Badge(
            key: Key("wtb-${workType?.id}-m"),
            badgeColor: workType?.colour ?? Colors.transparent,
            shape: BadgeShape.square,
            borderRadius: 20,
            toAnimate: false,
            badgeContent: Text(workType?.name ?? "?",
                style: TextStyle(
                    color: workType?.name != null
                        ? Colors.white
                        : Theme.of(context).disabledColor)),
          );
  }
}
