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
import 'package:timecop/blocs/work_types/bloc.dart';
import 'package:timecop/blocs/work_types/work_types_bloc.dart';
import 'package:timecop/components/WorkTypeBadge.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class WorkTypeSelectField extends StatefulWidget {
  WorkTypeSelectField({Key key}) : super(key: key);

  @override
  _WorkTypeSelectFieldState createState() => _WorkTypeSelectFieldState();
}

class _WorkTypeSelectFieldState extends State<WorkTypeSelectField> {
  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    assert(bloc != null);
    final WorkTypesBloc workTypesBloc = BlocProvider.of<WorkTypesBloc>(context);
    assert(workTypesBloc != null);
    return BlocBuilder<WorkTypesBloc, WorkTypesState>(
        builder: (BuildContext context, WorkTypesState workTypesState) {
      return BlocBuilder<DashboardBloc, DashboardState>(
        bloc: bloc,
        builder: (BuildContext context, DashboardState state) {
          // detect if the workType we had selected was deleted
          if (state.newWorkType != null &&
              workTypesBloc.getWorkTypeByID(state.newWorkType.id) == null) {
            bloc.add(WorkTypeChangedEvent(null));
            return IconButton(
              alignment: Alignment.centerLeft,
              icon: WorkTypeBadge(workType: null),
              onPressed: null,
            );
          }

          return IconButton(
            alignment: Alignment.centerLeft,
            icon: WorkTypeBadge(workType: state.newWorkType),
            onPressed: () async {
              WorkType chosenWorkType = await showDialog<WorkType>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text(L10N.of(context).tr.workTypes),
                      contentPadding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 16.0),
                      children: <WorkType>[null]
                          .followedBy(workTypesState.workTypes)
                          .map((WorkType w) => FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop(w);
                              },
                              child: Row(
                                children: <Widget>[
                                  WorkTypeBadge(workType: w),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    child: Text(
                                        w?.name ??
                                            L10N.of(context).tr.noWorkType,
                                        style: TextStyle(
                                            color: w == null
                                                ? Theme.of(context)
                                                    .disabledColor
                                                : Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .color)),
                                  ),
                                ],
                              )))
                          .toList(),
                    );
                  });
              bloc.add(WorkTypeChangedEvent(chosenWorkType));
            },
          );
        },
      );
    });
  }
}
