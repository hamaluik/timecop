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
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

abstract class DataProvider {
  Future<Project> createProject({required String name, Color? colour});
  Future<List<Project>> listProjects();
  Future<void> editProject(Project project);
  Future<void> deleteProject(Project project);
  Future<TimerEntry> createTimer(
      {String? description,
      int? projectID,
      DateTime? startTime,
      DateTime? endTime});
  Future<List<TimerEntry>> listTimers();
  Future<void> editTimer(TimerEntry timer);
  Future<void> deleteTimer(TimerEntry timer);
  //Future<void> factoryReset();

  Future<void> import(DataProvider other) async {
    List<TimerEntry> otherEntries = await other.listTimers();
    List<Project> otherProjects = await other.listProjects();

    // Insert the other projects first, getting new IDs from them
    List<Project> newOtherProjects = await Stream.fromIterable(otherProjects)
        .asyncMap((p) => createProject(name: p.name, colour: p.colour))
        .toList();

    // Now insert the other entries, mapping the old project IDs to the new
    // project IDs that we just created
    for (TimerEntry otherEntry in otherEntries) {
      // map the old project ID to its corresponding new one
      int projectOffset =
          otherProjects.indexWhere((p) => p.id == otherEntry.projectID);
      int? projectID;
      if (projectOffset >= 0) {
        projectID = newOtherProjects[projectOffset].id;
      }

      await createTimer(
          description: otherEntry.description,
          projectID: projectID,
          startTime: otherEntry.startTime,
          endTime: otherEntry.endTime);
    }
  }
}
