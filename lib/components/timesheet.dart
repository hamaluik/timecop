import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/work_types/work_types_bloc.dart';
import 'package:timecop/components/project_data.dart';
import 'package:timecop/components/week_data.dart';
import 'package:timecop/components/worktype_data.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

import 'TimesheetRow.dart';

class Timesheet {
  final DateTime endOfWeekOnSunday;
  final List<Project> projects;
  final List<WorkType> workTypes;
  final List<TimerEntry> timers;

  final rows = <TimesheetRow>[];

  final TIMESHEET_JSON_DATE_FORMAT = 'yyyy-MM-dd';

  // TODO use I10N for the following strings
  static final Map<String, String> workTypeNames = {
    'reqs': 'Requirements Gathering',
    'dev': 'Development',
    'doc': 'Documentation',
    'test': 'Testing Support',
    'dep': 'Deployment',
    'misc': 'Miscellaneous'
  };

  Timesheet(
      {@required this.endOfWeekOnSunday,
      @required this.projects,
      @required this.workTypes,
      @required this.timers})
      : assert(endOfWeekOnSunday != null),
        assert(endOfWeekOnSunday.weekday == DateTime.sunday),
        assert(projects != null),
        assert(workTypes != null),
        assert(timers != null) {
    _processTimers();
  }

  void addProjectData(Project project, ProjectData projectData) {
    projectData.workTypes.forEach((workTypeID, workTypeData) {
      WorkType workType;
      if (workTypeID != null) {
        workType = WorkTypesBloc.getWorkTypeByIDFromList(workTypes, workTypeID);
      }
      var timesheetRow = TimesheetRow(
          project: project, workType: workType, workTypeData: workTypeData);
      rows.add(timesheetRow);
    });
  }

  void _processTimers() {
    if (timers.isNotEmpty) {
      var mapOfWeeks = <DateTime, WeekData>{};

      for (var timer in timers) {
        var discount = 0.0;
        _addWorkTimeFromTimer(mapOfWeeks, timer, discount);
      }
      _processWeekData(mapOfWeeks[endOfWeekOnSunday]);
    }
  }

  void _processWeekData(WeekData weekData) {
    weekData.projects.forEach((projectID, projectData) {
      Project project;
      if (projectID != null) {
        project = ProjectsBloc.getProjectByIDFromList(projects, projectID);
      }
      addProjectData(project, projectData);
    });
  }

  static void _addToGroup(
      Map<DateTime, WeekData> mapOfWeeks,
      DateTime aEndOfWeekDate,
      int aProjectID,
      int aWorkTypeID,
      String aNote,
      int aDayOfWeekNum,
      double aMins) {
    var weekData = mapOfWeeks.putIfAbsent(aEndOfWeekDate, () => WeekData());
    var projectData =
        weekData.projects.putIfAbsent(aProjectID, () => ProjectData());
    var workTypeData =
        projectData.workTypes.putIfAbsent(aWorkTypeID, () => WorkTypeData());
    workTypeData.noteMinutes.putIfAbsent(aNote, () => 0.0);

    workTypeData.noteMinutes[aNote] += aMins;
    workTypeData.weekDayMinutes[aDayOfWeekNum - 1] += aMins;
  }

  static int getWeekNum(DateTime aDate) {
    var dayOfYear = int.parse(DateFormat('D').format(aDate));
    return ((dayOfYear - aDate.weekday + 10) / 7).floor();
  }

  static DateTime getWeekEndOnSunday(DateTime aDate) {
    var sunday = aDate.add(Duration(days: DateTime.sunday - aDate.weekday));
    return DateTime(sunday.year, sunday.month, sunday.day);
  }

  static void _addWorkTimeFromTimer(
      Map<DateTime, WeekData> mapOfWeeks, TimerEntry timer, double discount) {
    _addWorkTimePart(mapOfWeeks, timer, timer.startTime, discount);
  }

  static void _addWorkTimePart(Map<DateTime, WeekData> mapOfWeeks,
      TimerEntry timer, DateTime startTime, double discount) {
    if (startTime.isBefore(timer.endTime)) {
      DateTime endTime;
      if (isSameDay(startTime, timer.endTime)) {
        endTime = timer.endTime;
      } else {
        // call this method again (recursively) to add the remaining time to
        // future days
        _addWorkTimePart(
            mapOfWeeks, timer, getStartOfNextDay(startTime), discount);

        // since all time past midnight on the start date was just added
        // via the recursive call above, below we will only process the
        // time on the start date
        endTime = getBeforeMidnightOfDay(startTime);
      }

      var mins = endTime.difference(startTime).inMinutes.toDouble();
      if (discount > 0) {
        mins = mins * (1 - discount);
      }
      _addToGroup(mapOfWeeks, getWeekEndOnSunday(startTime), timer.projectID,
          timer.workTypeID, timer.description, startTime.weekday, mins);
    }
  }

  static DateTime getStartOfNextDay(DateTime aDate) {
    return DateTime(aDate.year, aDate.month, aDate.day + 1, 0, 0, 0, 0);
  }

  static DateTime getBeforeMidnightOfDay(DateTime aDate) {
    return DateTime(aDate.year, aDate.month, aDate.day, 23, 59, 59, 999);
  }

  static bool isSameDay(DateTime day1, DateTime day2) {
    var day1ZeroTime = DateTime(day1.year, day1.month, day1.day);
    var day2ZeroTime = DateTime(day2.year, day2.month, day2.day);

    return (day1ZeroTime.compareTo(day2ZeroTime) == 0);
  }

  Map<String, dynamic> toJson() => _toJson(this);

  Map<String, dynamic> _toJson(Timesheet instance) {
    return <String, dynamic>{
      'endOfWeek': DateFormat(TIMESHEET_JSON_DATE_FORMAT)
          .format(instance.endOfWeekOnSunday),
      'rows': [...instance.rows.map((e) => e.toJson()).toList()],
    };
  }
}
