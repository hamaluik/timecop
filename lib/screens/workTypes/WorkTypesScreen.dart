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
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/work_types/bloc.dart';
import 'package:timecop/components/WorkTypeBadge.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/workTypes/WorkTypeEditor.dart';

class WorkTypesScreen extends StatelessWidget {
  const WorkTypesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkTypesBloc workTypesBloc = BlocProvider.of<WorkTypesBloc>(context);
    assert(workTypesBloc != null);
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    assert(settingsBloc != null);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.workTypes),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (BuildContext context, SettingsState settingsState) =>
            BlocBuilder<WorkTypesBloc, WorkTypesState>(
                bloc: workTypesBloc,
                builder: (BuildContext context, WorkTypesState state) {
                  return ListView(
                    children: state.workTypes
                        .map((workType) => Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.15,
                              child: ListTile(
                                leading: WorkTypeBadge(workType: workType),
                                title: Text(workType.name),
                                trailing: settingsState.defaultWorkTypeID ==
                                        workType.id
                                    ? Icon(FontAwesomeIcons.thumbtack)
                                    : null,
                                onTap: () => showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        WorkTypeEditor(
                                          workType: workType,
                                        )),
                              ),
                              actions: <Widget>[
                                IconSlideAction(
                                  color: Theme.of(context).errorColor,
                                  foregroundColor:
                                      Theme.of(context).accentIconTheme.color,
                                  icon: FontAwesomeIcons.trash,
                                  onTap: () async {
                                    bool delete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text(L10N
                                                  .of(context)
                                                  .tr
                                                  .confirmDelete),
                                              content: RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .body1
                                                                  .color),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: L10N
                                                                    .of(context)
                                                                    .tr
                                                                    .areYouSureYouWantToDeleteWorkType +
                                                                "\n\n"),
                                                        TextSpan(
                                                            text: "⬤ ",
                                                            style: TextStyle(
                                                                color: workType
                                                                    .colour)),
                                                        TextSpan(
                                                            text: workType.name,
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic)),
                                                      ])),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(L10N
                                                      .of(context)
                                                      .tr
                                                      .cancel),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                ),
                                                FlatButton(
                                                  child: Text(L10N
                                                      .of(context)
                                                      .tr
                                                      .delete),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                ),
                                              ],
                                            ));
                                    if (delete) {
                                      workTypesBloc
                                          .add(DeleteWorkType(workType));
                                    }
                                  },
                                )
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                    color: workType.id ==
                                            settingsState.defaultWorkTypeID
                                        ? Theme.of(context).errorColor
                                        : Theme.of(context).accentColor,
                                    foregroundColor:
                                        Theme.of(context).accentIconTheme.color,
                                    icon: FontAwesomeIcons.thumbtack,
                                    onTap: () {
                                      settingsBloc.add(SetDefaultWorkTypeID(
                                          workType.id ==
                                                  settingsState
                                                      .defaultWorkTypeID
                                              ? null
                                              : workType.id));
                                    })
                              ],
                            ))
                        .toList(),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("addWorkType"),
        child: Stack(
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
            builder: (BuildContext context) => WorkTypeEditor(
                  workType: null,
                )),
      ),
    );
  }
}
