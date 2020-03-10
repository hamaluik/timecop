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
import 'package:timecop/data_providers/data_provider.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

class MockDataProvider extends DataProvider {
  Future<List<Project>> listProjects() async {
    return <Project>[
      Project(id: 1, name: "Time Cop", colour: Colors.cyan[600]),
      Project(id: 2, name: "Administration", colour: Colors.pink[600]),
    ];
  }
  Future<List<TimerEntry>> listTimers() async {
    return <TimerEntry>[
      TimerEntry(
        id: 1,
        description: "Wireframing",
        projectID: 1,
        startTime: DateTime.now().subtract(Duration(days: 2, hours: 9, minutes: 22)),
        endTime: DateTime.now().subtract(Duration(days: 2)),
      ),
      TimerEntry(
        id: 2,
        description: "Mockups",
        projectID: 1,
        startTime: DateTime.now().subtract(Duration(days: 1, hours: 7, minutes: 9)),
        endTime: DateTime.now().subtract(Duration(days: 1))
      ),
      TimerEntry(
        id: 3,
        description: "Client Meeting",
        projectID: 2,
        startTime: DateTime.now().subtract(Duration(days: 1, hours: 0, minutes: 42)),
        endTime: DateTime.now().subtract(Duration(days: 1))
      ),
      TimerEntry(
        id: 1,
        description: "UI Layout",
        projectID: 1,
        startTime: DateTime.now().subtract(Duration(hours: 2, minutes: 10)),
        endTime: null,
      ),
      TimerEntry(
        id: 1,
        description: "Coffee",
        projectID: 2,
        startTime: DateTime.now().subtract(Duration(minutes: 3)),
        endTime: null,
      ),
    ];
  }

  Future<Project> createProject({@required String name, Color colour}) async {
    return Project(id: -1, name: name, colour: colour);
  }
  Future<void> editProject(Project project) async {}
  Future<void> deleteProject(Project project) async {}
  Future<TimerEntry> createTimer({String description, int projectID, DateTime startTime, DateTime endTime}) async {
    return TimerEntry(
      id: -1,
      description: description,
      projectID: projectID,
      startTime: startTime,
      endTime: endTime,
    );
  }
  Future<void> editTimer(TimerEntry timer) async {}
  Future<void> deleteTimer(TimerEntry timer) async {}
}