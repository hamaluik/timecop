import 'dart:collection';
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
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/timer_group.dart';
import 'package:path/path.dart' as p;

import 'exporter_data.dart';

class Exporter {
  final BuildContext context;
  final ExporterData exporterData;
  Exporter({@required this.context, @required this.exporterData})
      : assert(context != null),
        assert(exporterData != null);

  Future<void> exportTimeEntries() async {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    assert(settingsBloc != null);

    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);
    assert(timers != null);

    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    assert(projects != null);

    final WorkTypesBloc workTypes = BlocProvider.of<WorkTypesBloc>(context);
    assert(workTypes != null);

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

    // group similar timers if that's what you're in to
    if (settingsBloc.state.exportGroupTimers &&
        !(settingsBloc.state.exportIncludeStartTime ||
            settingsBloc.state.exportIncludeEndTime)) {
      filteredTimers = timers.state.timers
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

      // now start grouping those suckers
      LinkedHashMap<String, LinkedHashMap<TimerGroup, List<TimerEntry>>> derp =
          LinkedHashMap();
      for (TimerEntry timer in filteredTimers) {
        String date = ExporterData.exportDateFormat.format(timer.startTime);
        LinkedHashMap<TimerGroup, List<TimerEntry>> pairedEntries =
            derp.putIfAbsent(date, () => LinkedHashMap());
        List<TimerEntry> pairedList = pairedEntries.putIfAbsent(
            TimerGroup(timer.projectID, timer.workTypeID, timer.description),
            () => <TimerEntry>[]);
        pairedList.add(timer);
      }

      // ok, now they're grouped based on date, then combined project, workTYpe, description combos
      // time to get them back into a flat list
      filteredTimers = derp.values
          .expand((LinkedHashMap<TimerGroup, List<TimerEntry>> pairedEntries) {
        return pairedEntries.values.map((List<TimerEntry> groupedEntries) {
          assert(groupedEntries.isNotEmpty);

          // not a grouped entry
          if (groupedEntries.length == 1) return groupedEntries[0];

          // yes a group entry, build a dummy timer entry
          Duration totalTime = groupedEntries.fold(
              Duration(),
              (Duration d, TimerEntry t) =>
                  d + t.endTime.difference(t.startTime));
          return TimerEntry.clone(groupedEntries[0],
              endTime: groupedEntries[0].startTime.add(totalTime));
        });
      }).toList();
    }

    List<List<String>> data =
        <List<String>>[headers].followedBy(filteredTimers.map((timer) {
      List<String> row = [];
      if (settingsBloc.state.exportIncludeDate) {
        row.add(ExporterData.exportDateFormat.format(timer.startTime));
      }
      if (settingsBloc.state.exportIncludeProject) {
        row.add(projects.getProjectByID(timer.projectID)?.name ?? "");
      }
      if (settingsBloc.state.exportIncludeWorkType) {
        row.add(workTypes.getWorkTypeByID(timer.workTypeID)?.name ?? "");
      }
      if (settingsBloc.state.exportIncludeDescription) {
        row.add(timer.description ?? "");
      }
      if (settingsBloc.state.exportIncludeProjectDescription) {
        row.add((projects.getProjectByID(timer.projectID)?.name ?? "") +
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
    String csv = ListToCsvConverter().convert(data);
    print('CSV:');
    print(csv);

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

    final String localPath = '${directory.path}/timecop.csv';
    File file = File(localPath);
    await file.writeAsString(csv, flush: true);
    await FlutterShare.shareFile(
        title: L10N.of(context).tr.timeCopEntries(timestamp),
        filePath: localPath);
  }

  Future<void> exportDatabase() async {
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
}
