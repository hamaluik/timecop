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
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/timer/TimerEditor.dart';

class RunningTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final DateTime now;
  const RunningTimerRow({Key? key, required this.timer, required this.now})
      : super(key: key);

  static String formatDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return L10N.of(context).tr.noDescription;
    }
    return description;
  }

  static TextStyle? styleDescription(
      BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return TextStyle(color: Theme.of(context).disabledColor);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: <Widget>[
            SlidableAction(
              backgroundColor: Theme.of(context).errorColor,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              icon: FontAwesomeIcons.trash,
              onPressed: (_) async {
                bool? delete = await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(L10N.of(context).tr.confirmDelete),
                          content: Text(L10N.of(context).tr.deleteTimerConfirm),
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
                        ));
                if (delete == true) {
                  final TimersBloc timersBloc =
                      BlocProvider.of<TimersBloc>(context);
                  timersBloc.add(DeleteTimer(timer));
                }
              },
            )
          ]),
      endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: <Widget>[
            SlidableAction(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              icon: FontAwesomeIcons.solidCircleStop,
              onPressed: (_) {
                final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
                timers.add(StopTimer(timer));
              },
            )
          ]),
      child: ListTile(
          leading: ProjectColour(
              project: BlocProvider.of<ProjectsBloc>(context)
                  .getProjectByID(timer.projectID)),
          title: Text(formatDescription(context, timer.description),
              style: styleDescription(context, timer.description)),
          trailing: Text(timer.formatTime(),
              style: TextStyle(fontFamily: "FiraMono")),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
                builder: (BuildContext context) => TimerEditor(
                  timer: timer,
                ),
                fullscreenDialog: true,
              ))),
    );
  }
}
