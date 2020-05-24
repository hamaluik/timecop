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
import 'package:flutter/foundation.dart';

class TimerEntry extends Equatable {
  final int id;
  final String description;
  final int projectID;
  final int workTypeID;
  final DateTime startTime;
  final DateTime endTime;

  TimerEntry(
      {@required this.id,
      @required this.description,
      @required this.projectID,
      @required this.workTypeID,
      @required this.startTime,
      @required this.endTime})
      : assert(id != null),
        assert(startTime != null);

  @override
  List<Object> get props =>
      [id, description, projectID, workTypeID, startTime, endTime];

  @override
  bool get stringify => true;

  TimerEntry.clone(TimerEntry timer,
      {String description,
      int projectID,
      int workTypeID,
      DateTime startTime,
      DateTime endTime})
      : this(
          id: timer.id,
          description: description ?? timer.description,
          projectID: projectID ?? timer.projectID,
          workTypeID: workTypeID ?? timer.workTypeID,
          startTime: startTime ?? timer.startTime,
          endTime: endTime ?? timer.endTime,
        );

  static String formatDuration(Duration d) {
    if (d.inHours > 0) {
      return d.inHours.toString() +
          ":" +
          (d.inMinutes - (d.inHours * 60)).toString().padLeft(2, "0") +
          ":" +
          (d.inSeconds - (d.inMinutes * 60)).toString().padLeft(2, "0");
    } else {
      return d.inMinutes.toString().padLeft(2, "0") +
          ":" +
          (d.inSeconds - (d.inMinutes * 60)).toString().padLeft(2, "0");
    }
  }

  String formatTime() {
    Duration d = (endTime ?? DateTime.now()).difference(startTime);
    return formatDuration(d);
  }
}
