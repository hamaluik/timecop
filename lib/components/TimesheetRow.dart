import 'package:flutter/foundation.dart';
import 'package:timecop/components/worktype_data.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';

class TimesheetRow {
  final Project project;
  final WorkType workType;
  String notes = '';
  final dayHrs = <double>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  double totalHours = 0;

  final int minBlockOfMins = 15;

  TimesheetRow({this.project, this.workType, WorkTypeData workTypeData}) {
    workTypeData.noteMinutes.forEach((note, noteMinutes) {
      if (notes.isNotEmpty) {
        notes = notes + '; ';
      }
      var noteMins = noteMinutes.round();
      String timeStr;
      if (noteMins < 60) {
        timeStr = '${noteMins}m';
      } else {
        var noteHrs = (noteMins / 60).floor();
        noteMins = noteMins - noteHrs * 60;
        timeStr = '${noteHrs}h ${noteMins}m';
      }
      notes = notes + note + '[' + timeStr + ']';
    });

    for (var day = DateTime.monday; day <= DateTime.sunday; day++) {
      int dayIdx = day - 1;
      var mins = applyMinBlockOfTime(workTypeData.weekDayMinutes[dayIdx]);
      var hrs = mins / 60;
      hrs = ((hrs * 100).roundToDouble()) / 100;
      dayHrs[dayIdx] = hrs;
      totalHours = totalHours + hrs;
    }
  }

  int applyMinBlockOfTime(double mins) {
    return (mins / minBlockOfMins).round() * minBlockOfMins;
  }

  Map<String, dynamic> toJson() => _toJson(this);

  Map<String, dynamic> _toJson(TimesheetRow instance) {
    return <String, dynamic>{
      'project': instance.project?.getProjectCode(),
      'workType': instance.workType?.name,
      'notes': instance.notes,
      'totalHours': instance.totalHours,
      'dayHours': instance.dayHrs,
    };
  }
}
