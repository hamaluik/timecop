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
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

abstract class TimersEvent extends Equatable {
  const TimersEvent();
}

class LoadTimers extends TimersEvent {
  @override
  List<Object> get props => [];
}

class CreateTimer extends TimersEvent {
  final String? description;
  final Project? project;
  const CreateTimer({this.description, this.project});
  @override
  List<Object?> get props => [description, project];
}

class UpdateNow extends TimersEvent {
  const UpdateNow();
  @override
  List<Object> get props => [];
}

class StopTimer extends TimersEvent {
  final TimerEntry timer;
  const StopTimer(this.timer);
  @override
  List<Object> get props => [timer];
}

class EditTimer extends TimersEvent {
  final TimerEntry timer;
  const EditTimer(this.timer);
  @override
  List<Object> get props => [timer];
}

class DeleteTimer extends TimersEvent {
  final TimerEntry timer;
  const DeleteTimer(this.timer);
  @override
  List<Object> get props => [timer];
}

class StopAllTimers extends TimersEvent {
  const StopAllTimers();
  @override
  List<Object> get props => [];
}
