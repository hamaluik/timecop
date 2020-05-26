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
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

abstract class DataProvider {
  Future<Project> createProject({@required String name, Color colour});

  Future<List<Project>> listProjects();

  Future<void> editProject(Project project);

  Future<void> deleteProject(Project project);

  Future<WorkType> createWorkType({@required String name, Color colour});

  Future<List<WorkType>> listWorkTypes();

  Future<void> editWorkType(WorkType workType);

  Future<void> deleteWorkType(WorkType workType);

  Future<TimerEntry> createTimer(
      {String description,
      int projectID,
      int workTypeID,
      DateTime startTime,
      DateTime endTime});

  Future<List<TimerEntry>> listTimers();

  Future<void> editTimer(TimerEntry timer);

  Future<void> deleteTimer(TimerEntry timer);
}
