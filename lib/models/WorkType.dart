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

class WorkType extends Equatable {
  final int id;
  final String name;
  final Color colour;

  WorkType({@required this.id, @required this.name, @required this.colour})
      : assert(id != null),
        assert(name != null),
        assert(colour != null);

  @override
  List<Object> get props => [id, name, colour];
  @override
  bool get stringify => true;

  WorkType.clone(WorkType workType, {String name, Color colour})
      : this(
          id: workType.id,
          name: name ?? workType.name,
          colour: colour ?? workType.colour,
        );
}
