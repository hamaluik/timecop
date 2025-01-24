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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/screens/dashboard/components/RowSeparator.dart';

class TimerDenseTrailing extends StatelessWidget {
  final Function(BuildContext) resumeTimer;
  final String durationString;

  const TimerDenseTrailing(
      {super.key, required this.resumeTimer, required this.durationString});

  @override
  Widget build(BuildContext context) {
    final directionality = Directionality.of(context);
    final tilePadding = Theme.of(context)
        .expansionTileTheme
        .tilePadding
        ?.resolve(directionality);
    final theme = Theme.of(context);

    return InkWell(
        onTap: () => resumeTimer(context),
        child: Padding(
            padding: EdgeInsetsDirectional.only(
                end: (directionality == TextDirection.ltr
                        ? tilePadding?.right
                        : tilePadding?.left) ??
                    16,
                top: tilePadding?.top ?? 0,
                bottom: tilePadding?.bottom ?? 0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const RowSeparator(),
                  ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 66),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(durationString,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              )),
                          const SizedBox(height: 8),
                          const Icon(FontAwesomeIcons.play, size: 16)
                        ],
                      ))
                ])));
  }
}
