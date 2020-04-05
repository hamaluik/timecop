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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/components/start_end_times/bloc/startendtimes_bloc.dart';
import 'package:timecop/l10n.dart';

DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy h:mma");

class StartEndTimers extends StatelessWidget {
  final StartEndTimesBloc bloc;
  final bool canClearStartTime;
  const StartEndTimers({Key key, @required this.bloc, this.canClearStartTime = true})
    : assert(bloc != null),
      assert(canClearStartTime != null),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, StartEndTimesState state) {
        return Column(
          children: <Widget>[
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: ListTile(
                title: Text(L10N.of(context).tr.startTime),
                trailing: Text(_dateFormat.format(state.start)),
                onTap: () async {
                  bloc.add(StartEditingTimeEvent());
                  DateTime newStartTime = await DatePicker.showDateTimePicker(
                    context,
                    currentTime: state.start,
                    maxTime: state.end == null ? DateTime.now() : null,
                    onChanged: (DateTime dt) => bloc.add(SetStartTimeEvent(dt)),
                    onConfirm: (DateTime dt) => bloc.add(SetStartTimeEvent(dt)),
                    theme: DatePickerTheme(
                      cancelStyle: Theme.of(context).textTheme.button,
                      doneStyle: Theme.of(context).textTheme.button,
                      itemStyle: Theme.of(context).textTheme.body1,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    )
                  );

                  // if the user cancelled, this should be null
                  if(newStartTime == null) {
                    bloc.add(CancelSetTimeEvent());
                  }
                  else {
                    bloc.add(SaveTimeEvent());
                  }
                },
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  color: Theme.of(context).accentColor,
                  foregroundColor: Theme.of(context).accentIconTheme.color,
                  icon: FontAwesomeIcons.clock,
                  onTap: () {
                    bloc.add(StartEditingTimeEvent());
                    bloc.add(SetStartTimeEvent(DateTime.now()));
                    bloc.add(SaveTimeEvent());
                  },
                ),
              ],
            ),
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.15,
              child: ListTile(
                title: Text(L10N.of(context).tr.endTime),
                trailing: Text(state.end == null ? "—" : _dateFormat.format(state.end)),
                onTap: () async {
                bloc.add(StartEditingTimeEvent());
                DateTime newEndTime = await DatePicker.showDateTimePicker(
                    context,
                    currentTime: state.end,
                    minTime: state.start,
                    onChanged: (DateTime dt) => bloc.add(SetEndTimeEvent(dt)),
                    onConfirm: (DateTime dt) => bloc.add(SetEndTimeEvent(dt)),
                    theme: DatePickerTheme(
                      cancelStyle: Theme.of(context).textTheme.button,
                      doneStyle: Theme.of(context).textTheme.button,
                      itemStyle: Theme.of(context).textTheme.body1,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    )
                  );

                  // if the user cancelled, this should be null
                  if(newEndTime == null) {
                    bloc.add(CancelSetTimeEvent());
                  }
                  else {
                    bloc.add(SaveTimeEvent());
                  }
                },
              ),
              secondaryActions:
                state.end == null
                  ? <Widget>[
                    IconSlideAction(
                      color: Theme.of(context).accentColor,
                      foregroundColor: Theme.of(context).accentIconTheme.color,
                      icon: FontAwesomeIcons.clock,
                      onTap: () {
                        bloc.add(StartEditingTimeEvent());
                        bloc.add(SetEndTimeEvent(DateTime.now()));
                        bloc.add(SaveTimeEvent());
                      },
                    ),
                  ]
                  : <Widget>[
                    IconSlideAction(
                      color: Theme.of(context).accentColor,
                      foregroundColor: Theme.of(context).accentIconTheme.color,
                      icon: FontAwesomeIcons.clock,
                      onTap: () {
                        bloc.add(StartEditingTimeEvent());
                        bloc.add(SetEndTimeEvent(DateTime.now()));
                        bloc.add(SaveTimeEvent());
                      },
                    ),
                    IconSlideAction(
                      color: Theme.of(context).errorColor,
                      foregroundColor: Theme.of(context).accentIconTheme.color,
                      icon: FontAwesomeIcons.minusCircle,
                      onTap: () {
                        bloc.add(StartEditingTimeEvent());
                        bloc.add(SetEndTimeEvent(null));
                        bloc.add(SaveTimeEvent());
                      },
                    )
                  ],
            ),
          ],
        );
      },
    );
  }
}