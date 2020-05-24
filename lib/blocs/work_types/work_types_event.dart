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

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timecop/models/WorkType.dart';

abstract class WorkTypesEvent extends Equatable {
  const WorkTypesEvent();
}

class LoadWorkTypes extends WorkTypesEvent {
  @override
  List<Object> get props => [];
}

class CreateWorkType extends WorkTypesEvent {
  final String name;
  final Color colour;

  const CreateWorkType(this.name, this.colour)
      : assert(name != null),
        assert(colour != null);

  @override
  List<Object> get props => [name, colour];
}

class EditWorkType extends WorkTypesEvent {
  final WorkType workType;

  const EditWorkType(this.workType) : assert(workType != null);

  @override
  List<Object> get props => [workType];
}

class DeleteWorkType extends WorkTypesEvent {
  final WorkType workType;

  const DeleteWorkType(this.workType) : assert(workType != null);

  @override
  List<Object> get props => [workType];
}
