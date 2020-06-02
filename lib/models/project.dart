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

class Project extends Equatable {
  final int id;
  final String name;
  final Color colour;

  Project({@required this.id, @required this.name, @required this.colour})
      : assert(id != null),
        assert(name != null),
        assert(colour != null);

  @override
  List<Object> get props => [id, name, colour];
  @override
  bool get stringify => true;

  Project.clone(Project project, {String name, Color colour})
      : this(
          id: project.id,
          name: name ?? project.name,
          colour: colour ?? project.colour,
        );
}
