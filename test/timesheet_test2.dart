import 'package:test/test.dart';
import 'package:timecop/blocs/work_types/bloc.dart';
import 'package:timecop/components/TimesheetRow.dart';
import 'package:timecop/components/timesheet.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:flutter/material.dart';

void main() {
  group('Timesheet2', () {
    var endOfWeekOnSunday = Timesheet.getWeekEndOnSunday(
        DateTime.now().subtract(Duration(days: 7)));

    var projects = <Project>[];
    var workTypes = <WorkType>[];
    var timers = <TimerEntry>[];

    test('rows should have 1 element', () {
      var project = Project(id: 1, name: 'ITR6203', colour: Colors.red);
      projects.add(project);
      var workType = WorkType(id: 1, name: 'dev', colour: Colors.blue);
      workTypes.add(workType);
      var startTime =
          endOfWeekOnSunday.subtract(Duration(days: 4, hours: 14, minutes: 56));
      var note = 'Jill: testing';
      var timerEntry1 = TimerEntry(
        id: 1,
        description: note,
        projectID: project.id,
        workTypeID: workType.id,
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: 13)),
      );

      timers.add(timerEntry1);
      var timesheet = Timesheet(
          endOfWeekOnSunday: endOfWeekOnSunday,
          projects: projects,
          workTypes: workTypes,
          timers: timers);
      expect(timesheet.rows.isEmpty, equals(false));
      expect(timesheet.rows.length, equals(1));
      var tsRow = timesheet.rows[0];
      expect(tsRow.project.name, equals(project.name));
      expect(tsRow.workType.name, equals(workType.name));
      expect(tsRow.notes, equals('${note}[13m]'));
      expect(tsRow.dayHrs[startTime.weekday - 1], equals(15 / 60));
    });
  });
}
