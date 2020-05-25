import 'package:test/test.dart';
import 'package:timecop/components/timesheet.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:flutter/material.dart';

void main() {
  group('Timesheet', () {
    var endOfWeekOnSunday = Timesheet.getWeekEndOnSunday(
        DateTime.now().subtract(Duration(days: 7)));

    var projects = <Project>[];
    var workTypes = <WorkType>[];
    var timers = <TimerEntry>[];

    test('rows should be empty', () {
      var timesheet = Timesheet(
          endOfWeekOnSunday: endOfWeekOnSunday,
          projects: projects,
          workTypes: workTypes,
          timers: timers);
      expect(timesheet.rows.isEmpty, true);
    });

    var project2 =
        Project(id: 2, name: 'ADHOC0998953 A task for Joe', colour: Colors.red);
    projects.add(project2);
    var workType2 = WorkType(id: 2, name: 'doc', colour: Colors.blue);
    workTypes.add(workType2);
    var startTime2 =
        endOfWeekOnSunday.subtract(Duration(days: 3, hours: 8, minutes: 23));
    var note2 = 'Elaine: doc mtg';
    var timerEntry2 = TimerEntry(
      id: 2,
      description: note2,
      projectID: project2.id,
      workTypeID: workType2.id,
      startTime: startTime2,
      endTime: startTime2.add(Duration(days: 2)),
    );

    test('multi-day events should be split across days', () {
      timers.add(timerEntry2);
      var timesheet = Timesheet(
          endOfWeekOnSunday: endOfWeekOnSunday,
          projects: projects,
          workTypes: workTypes,
          timers: timers);
      expect(timesheet.rows.isEmpty, equals(false));
      expect(timesheet.rows.length, equals(1));
      var tsRow = timesheet.rows[0];
      expect(tsRow.project.name, equals(project2.name));
      expect(tsRow.workType.name, equals(workType2.name));
      expect(tsRow.notes, equals('${note2}[47h 58m]'));
      expect(tsRow.dayHrs[startTime2.weekday - 1], equals(8.25));
      expect(tsRow.dayHrs[startTime2.weekday], equals(24.0));
      expect(tsRow.dayHrs[startTime2.weekday + 1], equals(15.5));

      print(timesheet.toJson());
    });
  });
}
