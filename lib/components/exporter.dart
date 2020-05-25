import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';
import 'package:timecop/blocs/work_types/work_types_bloc.dart';
import 'package:timecop/components/timesheet.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/proj_work_desc_data.dart';
import 'package:path/path.dart' as p;

import 'exporter_data.dart';

class Exporter {
  final BuildContext context;
  final ExporterData exporterData;
  Exporter({@required this.context, @required this.exporterData})
      : assert(context != null),
        assert(exporterData != null);

  static final DateFormat exportDateFormat = DateFormat.yMd();

  SettingsBloc settingsBloc = null;
  TimersBloc timersBloc = null;
  ProjectsBloc projectsBloc = null;
  WorkTypesBloc workTypesBloc = null;

  void _init() {
    if (settingsBloc == null) {
      settingsBloc = BlocProvider.of<SettingsBloc>(context);
      assert(settingsBloc != null);
    }

    if (timersBloc == null) {
      timersBloc = BlocProvider.of<TimersBloc>(context);
      assert(timersBloc != null);
    }

    if (projectsBloc == null) {
      projectsBloc = BlocProvider.of<ProjectsBloc>(context);
      assert(projectsBloc != null);
    }

    if (workTypesBloc == null) {
      workTypesBloc = BlocProvider.of<WorkTypesBloc>(context);
      assert(workTypesBloc != null);
    }
  }

  Future<void> exportTimeEntries() async {
    _init();
    List<TimerEntry> filteredTimers = _getFilteredAndSortedTimers(timersBloc);

    if (settingsBloc.state.exportTimesheet) {
      await _exportTimesheet(filteredTimers);
    } else {
      await _exportCsv(filteredTimers);
    }
  }

  Future<void> _exportTimesheet(List<TimerEntry> timers) async {
    var endOfWeekOnSunday =
        Timesheet.getWeekEndOnSunday(exporterData.startDate);

    var timesheet = Timesheet(
        endOfWeekOnSunday: endOfWeekOnSunday,
        projects: projectsBloc.state.projects,
        workTypes: workTypesBloc.state.workTypes,
        timers: timers);

    var encoder = JsonEncoder.withIndent('  ');
    var jsonDataPretty = encoder.convert(timesheet);

    await exportData('timecop-timesheet.json', jsonDataPretty,
        L10N.of(context).tr.timeSheetExportFileName);
  }

  Future<void> _exportCsv(List<TimerEntry> filteredTimers) async {
    // group similar timers if that's what you're in to
    if (settingsBloc.state.exportGroupTimers &&
        !(settingsBloc.state.exportIncludeStartTime ||
            settingsBloc.state.exportIncludeEndTime)) {
      filteredTimers = _groupDailyTimersByProjWorkDesc(filteredTimers);
    }

    List<List<String>> data = _convertTimersToRowsOfData(filteredTimers);

    String csv = ListToCsvConverter().convert(data);
//    print('CSV:');
//    print(csv);

    await exportData('timecop.csv', csv, L10N.of(context).tr.timeCopEntries);
  }

  void exportData(String localFileName, String data,
      String Function(String) fileNameFn) async {
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    String timestamp;
    DateFormat dateTimeFormatFilename = ExporterData.dateFormat;
    if (settingsBloc.state.exportIncludeTimeInFilename) {
      dateTimeFormatFilename = ExporterData.dateTimeFormat;
    }
    timestamp = dateTimeFormatFilename.format(DateTime.now());

    String dateRange = '';
    if (settingsBloc.state.exportIncludeDateRangeInFilename &&
        (exporterData.startDate != null || exporterData.endDate != null)) {
      String startDateStr = exporterData.startDate != null
          ? '${L10N.of(context).tr.from} ${ExporterData.dateFormat.format(exporterData.startDate)}'
          : '';
      String endDateStr = exporterData.endDate != null
          ? '${L10N.of(context).tr.to} ${ExporterData.dateFormat.format(exporterData.endDate)}'
          : '';
      dateRange = '[' + ('${startDateStr} ${endDateStr}'.trim()) + ']';

      // file name examples:
      // no time, no date range:
      //     Time Cop Entries (Sun, May 24, 2020)

      // with time, no date range:
      //     Time Cop Entries (Sun, May 24, 2020 20_11_12)

      // with time, with date range, but only start date of range
      //     Time Cop Entries (Sun, May 24, 2020 20_10_18 [From Mon, May 18, 2020])

      // with time, with date range
      //     Time Cop Entries (Sun, May 24, 2020 20_10_33 [From Mon, May 18, 2020 To Sat, May 23, 2020])

      timestamp = '${timestamp} ${dateRange}'.trim();
    }
    final String localPath = '${directory.path}/${localFileName}';
    File file = File(localPath);
    await file.writeAsString(data, flush: true);
    await FlutterShare.shareFile(
        title: fileNameFn(timestamp), filePath: localPath);
  }

  Future<void> exportDatabase() async {
    _init();
    var databasesPath = await getDatabasesPath();
    var dbPath = p.join(databasesPath, 'timecop.db');

    try {
      // on android, copy it somewhere where it can be shared
      if (Platform.isAndroid) {
        Directory directory = await getExternalStorageDirectory();
        File copiedDB =
            await File(dbPath).copy(p.join(directory.path, "timecop.db"));
        dbPath = copiedDB.path;
      }
      await FlutterShare.shareFile(
          title: L10N
              .of(context)
              .tr
              .timeCopDatabase(ExporterData.dateFormat.format(DateTime.now())),
          filePath: dbPath);
    } on Exception catch (e) {
      exporterData.scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 5),
      ));
    }
  }

  List<TimerEntry> _getFilteredAndSortedTimers(TimersBloc timers) {
    List<TimerEntry> filteredTimers = timers.state.timers
        .where((t) => t.endTime != null)
        .where((t) =>
            exporterData.selectedProjects.any((p) => p?.id == t.projectID))
        .where((t) =>
            exporterData.selectedWorkTypes.any((p) => p?.id == t.workTypeID))
        .where((t) => exporterData.startDate == null
            ? true
            : t.startTime.isAfter(exporterData.startDate))
        .where((t) => exporterData.endDate == null
            ? true
            : t.endTime.isBefore(exporterData.endDate))
        .toList();
    filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));
    return filteredTimers;
  }

  List<TimerEntry> _groupDailyTimersByProjWorkDesc(List<TimerEntry> timers) {
    // now start grouping those suckers
    LinkedHashMap<String, LinkedHashMap<ProjWorkDescData, List<TimerEntry>>>
        mapOfDaysOfGroupsOfTimers = LinkedHashMap();
    for (TimerEntry timer in timers) {
      /* TODO check if there is a problem with timers running past midnight.
         The following code appears to assume that timers will not extend past midnight.
         Either timers should be stopped or split at midnight (is this currently happening?)
         or this code needs to accommodate for timers that extend beyond the midnight.
       */
      String dateStrForTimer = exportDateFormat.format(timer.startTime);

      // get the map of Project-WorkType-Description groups for the day
      // based on this timer's start time. If it does not exist, then an empty
      // map is created.
      LinkedHashMap<ProjWorkDescData, List<TimerEntry>>
          mapOfProjWorkDescGroupsOnDay = mapOfDaysOfGroupsOfTimers.putIfAbsent(
              dateStrForTimer, () => LinkedHashMap());

      // get the list of timers for the Project-WorkType-Description group
      // that match this timer's data on the timer's date
      List<TimerEntry> listOfTimersForProjWorkDescGroupOnDay =
          mapOfProjWorkDescGroupsOnDay.putIfAbsent(
              ProjWorkDescData(
                  timer.projectID, timer.workTypeID, timer.description),
              () => <TimerEntry>[]);

      // add this timer to the Project-WorkType-Description group that matches
      // this timer's data on the timer's date.
      listOfTimersForProjWorkDescGroupOnDay.add(timer);
    }

    // ok, now we have a map of days with a child map of proj-work-desc groups
    // with a child list of timers.
    // time to get them back into a flat list
    timers = mapOfDaysOfGroupsOfTimers.values.expand(
        (LinkedHashMap<ProjWorkDescData, List<TimerEntry>>
            mapOfGroupsOfTimers) {
      return mapOfGroupsOfTimers.values
          .map((List<TimerEntry> listOfTimersInGroup) {
        assert(listOfTimersInGroup.isNotEmpty);

        // not a grouped entry
        if (listOfTimersInGroup.length == 1) return listOfTimersInGroup[0];

        // yes a group entry, build a dummy timer entry
        Duration totalTime = listOfTimersInGroup.fold(
            Duration(),
            (Duration d, TimerEntry t) =>
                d + t.endTime.difference(t.startTime));
        return TimerEntry.clone(listOfTimersInGroup[0],
            endTime: listOfTimersInGroup[0].startTime.add(totalTime));
      });
    }).toList();
    return timers;
  }

  List<List<String>> _convertTimersToRowsOfData(List<TimerEntry> timers) {
    List<String> headers = _getHeaders(settingsBloc);

    List<List<String>> data =
        <List<String>>[headers].followedBy(timers.map((timer) {
      List<String> row = [];
      if (settingsBloc.state.exportIncludeDate) {
        row.add(exportDateFormat.format(timer.startTime));
      }
      if (settingsBloc.state.exportIncludeProject) {
        row.add(projectsBloc.getProjectByID(timer.projectID)?.name ?? "");
      }
      if (settingsBloc.state.exportIncludeWorkType) {
        row.add(workTypesBloc.getWorkTypeByID(timer.workTypeID)?.name ?? "");
      }
      if (settingsBloc.state.exportIncludeDescription) {
        row.add(timer.description ?? "");
      }
      if (settingsBloc.state.exportIncludeProjectDescription) {
        row.add((projectsBloc.getProjectByID(timer.projectID)?.name ?? "") +
            ": " +
            (timer.description ?? ""));
      }
      if (settingsBloc.state.exportIncludeStartTime) {
        row.add(timer.startTime.toUtc().toIso8601String());
      }
      if (settingsBloc.state.exportIncludeEndTime) {
        row.add(timer.endTime.toUtc().toIso8601String());
      }
      if (settingsBloc.state.exportIncludeDurationHours) {
        row.add(
            (timer.endTime.difference(timer.startTime).inSeconds.toDouble() /
                    3600.0)
                .toStringAsFixed(4));
      }
      return row;
    })).toList();
    return data;
  }

  List<String> _getHeaders(SettingsBloc settingsBloc) {
    List<String> headers = [];
    if (settingsBloc.state.exportIncludeDate) {
      headers.add(L10N.of(context).tr.date);
    }
    if (settingsBloc.state.exportIncludeProject) {
      headers.add(L10N.of(context).tr.project);
    }
    if (settingsBloc.state.exportIncludeWorkType) {
      headers.add(L10N.of(context).tr.workType);
    }
    if (settingsBloc.state.exportIncludeDescription) {
      headers.add(L10N.of(context).tr.description);
    }
    if (settingsBloc.state.exportIncludeProjectDescription) {
      headers.add(L10N.of(context).tr.combinedProjectDescription);
    }
    if (settingsBloc.state.exportIncludeStartTime) {
      headers.add(L10N.of(context).tr.startTime);
    }
    if (settingsBloc.state.exportIncludeEndTime) {
      headers.add(L10N.of(context).tr.endTime);
    }
    if (settingsBloc.state.exportIncludeDurationHours) {
      headers.add(L10N.of(context).tr.timeH);
    }
    return headers;
  }
}
