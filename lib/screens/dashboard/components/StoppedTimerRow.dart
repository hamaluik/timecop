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
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/blocs/work_types/work_types_bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/timer/TimerEditor.dart';

import 'TimerTileBuilder.dart';

class StoppedTimerRow extends StatelessWidget {
  final TimerEntry timer;
  const StoppedTimerRow({Key key, @required this.timer})
      : assert(timer != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(timer.endTime != null);

    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    final TimerTileBuilder timerTileBuilder = TimerTileBuilder(context);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: ListTile(
          key: Key("stoppedTimer-" + timer.id.toString()),
          leading: ProjectColour(project: projects.getProjectByID(timer.projectID)),
          title: timerTileBuilder.getTitleWidget(timer),
          subtitle: timerTileBuilder.getSubTitleWidget(timer),
          trailing: Text(timer.formatTime(), style: TextStyle(fontFamily: "FiraMono")),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
                builder: (BuildContext context) => TimerEditor( timer: timer,),
                fullscreenDialog: true,
              ))
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
                      content: Text(L10N.of(context).tr.deleteTimerConfirm),
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
            if (delete) {
              final TimersBloc timersBloc = BlocProvider.of<TimersBloc>(context);
              assert(timersBloc != null);
              timersBloc.add(DeleteTimer(timer));
            }
          },
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
            color: Theme.of(context).accentColor,
            foregroundColor: Theme.of(context).accentIconTheme.color,
            icon: FontAwesomeIcons.play,
            onTap: () {
              final TimersBloc timersBloc = BlocProvider.of<TimersBloc>(context);
              assert(timersBloc != null);
              final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);
              assert(projectsBloc != null);
              Project project = projectsBloc.getProjectByID(timer.projectID);

              final WorkTypesBloc workTypesBloc = BlocProvider.of<WorkTypesBloc>(context);
              assert(workTypesBloc != null);
              WorkType workType = workTypesBloc.getWorkTypeByID(timer.workTypeID);

              final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
              if (!settingsBloc.state.allowMultipleActiveTimers) {
                timersBloc.add(StopAllTimers());
              }

              timersBloc.add(CreateTimer( description: timer.description, project: project, workType: workType));
            }
          )
      ],
    );
  }
}