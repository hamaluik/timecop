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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/models/WorkType.dart';

import './bloc.dart';

class WorkTypesBloc extends Bloc<WorkTypesEvent, WorkTypesState> {
  final DataProvider data;

  WorkTypesBloc(this.data);

  @override
  WorkTypesState get initialState => WorkTypesState.initial();

  @override
  Stream<WorkTypesState> mapEventToState(
    WorkTypesEvent event,
  ) async* {
    if (event is LoadWorkTypes) {
      List<WorkType> workTypes = await data.listWorkTypes();
      yield WorkTypesState(workTypes);
    } else if (event is CreateWorkType) {
      WorkType newWorkType =
          await data.createWorkType(name: event.name, colour: event.colour);
      List<WorkType> workTypes =
          state.workTypes.map((workType) => WorkType.clone(workType)).toList();
      workTypes.add(newWorkType);
      workTypes.sort((a, b) => a.name.compareTo(b.name));
      yield WorkTypesState(workTypes);
    } else if (event is EditWorkType) {
      await data.editWorkType(event.workType);
      List<WorkType> workTypes = state.workTypes.map((workType) {
        if (workType.id == event.workType.id)
          return WorkType.clone(event.workType);
        return WorkType.clone(workType);
      }).toList();
      workTypes.sort((a, b) => a.name.compareTo(b.name));
      yield WorkTypesState(workTypes);
    } else if (event is DeleteWorkType) {
      await data.deleteWorkType(event.workType);
      List<WorkType> workTypes = state.workTypes
          .where((p) => p.id != event.workType.id)
          .map((p) => WorkType.clone(p))
          .toList();
      yield WorkTypesState(workTypes);
    }
  }

  WorkType getWorkTypeByID(int id) {
    return getWorkTypeByIDFromList(state.workTypes, id);
  }

  static WorkType getWorkTypeByIDFromList(List<WorkType> worktypeList, int id) {
    if (id == null) return null;
    try {
      return worktypeList.singleWhere((w) => w.id == id);
    } catch (err) {
      return null;
    }
  }
}
