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

import 'dart:collection';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/project_description_pair.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

enum _DurationFormat { decimal, time, both }

class ExportUtils {
  //TODO add percentage of total as a possible column
  static List<TimerEntry> _getFilteredTimers(mat.BuildContext context,
      DateTime? startDate, DateTime? endDate, List<Project?> selectedProjects) {
    final timers = BlocProvider.of<TimersBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final projects = BlocProvider.of<ProjectsBloc>(context);

    List<TimerEntry> filteredTimers = timers.state.timers
        .where((t) => t.endTime != null)
        .where((t) => selectedProjects.any((p) => p?.id == t.projectID))
        .where((t) => startDate == null ? true : t.startTime.isAfter(startDate))
        .where((t) => endDate == null ? true : t.endTime!.isBefore(endDate))
        .where((t) => !(projects.getProjectByID(t.projectID)?.archived == true))
        .toList();
    filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));
    // group similar timers if that's what you're in to
    if (settingsBloc.state.exportGroupTimers &&
        !(settingsBloc.state.exportIncludeStartTime ||
            settingsBloc.state.exportIncludeEndTime)) {
      filteredTimers = timers.state.timers
          .where((t) => t.endTime != null)
          .where((t) => selectedProjects.any((p) => p?.id == t.projectID))
          .where(
              (t) => startDate == null ? true : t.startTime.isAfter(startDate))
          .where((t) => endDate == null ? true : t.endTime!.isBefore(endDate))
          .where(
              (t) => !(projects.getProjectByID(t.projectID)?.archived == true))
          .toList();
      filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));

      // now start grouping those suckers
      final LinkedHashMap<String,
              LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>> derp =
          LinkedHashMap();
      for (TimerEntry timer in filteredTimers) {
        String date = DateFormat.yMd().format(timer.startTime);
        LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>> pairedEntries =
            derp.putIfAbsent(date, () => LinkedHashMap());
        List<TimerEntry> pairedList = pairedEntries.putIfAbsent(
            ProjectDescriptionPair(timer.projectID, timer.description),
            () => <TimerEntry>[]);
        pairedList.add(timer);
      }

      // ok, now they're grouped based on date, then combined project + description pairs
      // time to get them back into a flat list
      filteredTimers = derp.values.expand(
          (LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>
              pairedEntries) {
        return pairedEntries.values.map((List<TimerEntry> groupedEntries) {
          assert(groupedEntries.isNotEmpty);

          // not a grouped entry
          if (groupedEntries.length == 1) return groupedEntries[0];

          // yes a group entry, build a dummy timer entry
          return TimerEntry.clone(groupedEntries[0],
              endTime: groupedEntries[0]
                  .startTime
                  .add(_getTotalTime(groupedEntries)));
        });
      }).toList();
    }
    return filteredTimers;
  }

  static _getTotalTime(List<TimerEntry> entries) => entries.fold<Duration>(
      const Duration(),
      (previousValue, timerEntry) =>
          previousValue + timerEntry.endTime!.difference(timerEntry.startTime));

  static List<List<String>> _preprocessData(
      mat.BuildContext context,
      List<TimerEntry> filteredTimers,
      _DurationFormat durationFormat,
      bool compactStartEndTimes) {
    final projects = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    final localizations = L10N.of(context);

    List<String> headers = [];
    if (settingsBloc.state.exportIncludeDate) {
      headers.add(localizations.tr.date);
    }
    if (settingsBloc.state.exportIncludeProject) {
      headers.add(localizations.tr.project);
    }
    if (settingsBloc.state.exportIncludeDescription) {
      headers.add(localizations.tr.description);
    }
    if (settingsBloc.state.exportIncludeProjectDescription) {
      headers.add(localizations.tr.combinedProjectDescription);
    }
    if (settingsBloc.state.exportIncludeStartTime) {
      headers.add(localizations.tr.startTime);
    }
    if (settingsBloc.state.exportIncludeEndTime) {
      headers.add(localizations.tr.endTime);
    }
    if (settingsBloc.state.exportIncludeDurationHours) {
      headers.add(localizations.tr.timeH);
    }
    if (settingsBloc.state.exportIncludeNotes) {
      headers.add(localizations.tr.notes);
    }

    return <List<String>>[headers].followedBy(filteredTimers.map((timer) {
      List<String> row = [];
      if (settingsBloc.state.exportIncludeDate) {
        row.add(DateFormat.yMd().format(timer.startTime));
      }
      if (settingsBloc.state.exportIncludeProject) {
        row.add(projects.getProjectByID(timer.projectID)?.name ?? "");
      }
      if (settingsBloc.state.exportIncludeDescription) {
        row.add(timer.description ?? "");
      }
      if (settingsBloc.state.exportIncludeProjectDescription) {
        row.add(
            "${projects.getProjectByID(timer.projectID)?.name ?? ""}: ${timer.description ?? ""}");
      }
      if (settingsBloc.state.exportIncludeStartTime) {
        if (compactStartEndTimes) {
          row.add(DateFormat.jm().format(timer.startTime.toUtc()));
        } else {
          row.add(timer.startTime.toUtc().toIso8601String());
        }
      }
      if (settingsBloc.state.exportIncludeEndTime) {
        if (compactStartEndTimes) {
          final duration = timer.endTime!.difference(timer.startTime);
          final dayIndicator = duration.inDays > 0
              ? " ${L10N.of(context).tr.plusXDays(duration.inDays)}"
              : "";
          row.add(
              DateFormat.jm().format(timer.endTime!.toUtc()) + dayIndicator);
        } else {
          row.add(timer.endTime!.toUtc().toIso8601String());
        }
      }
      if (settingsBloc.state.exportIncludeDurationHours) {
        final duration = timer.endTime!.difference(timer.startTime);
        row.add(_formatDuration(duration, durationFormat));
      }
      if (settingsBloc.state.exportIncludeNotes) {
        row.add(timer.notes?.trim() ?? "");
      }
      return row;
    })).toList();
  }

  static String _formatDuration(Duration duration, _DurationFormat format) {
    switch (format) {
      case _DurationFormat.decimal:
        return (duration.inSeconds.toDouble() / 3600.0).toStringAsFixed(4);
      case _DurationFormat.time:
        return duration.toString().split('.').first;
      case _DurationFormat.both:
        return "${duration.toString().split('.').first} (${(duration.inSeconds.toDouble() / 3600.0).toStringAsFixed(4)} h.)";
    }
  }

  static String toCSVString(mat.BuildContext context, DateTime? startDate,
      DateTime? endDate, List<Project?> selectedProjects) {
    final filteredTimers =
        _getFilteredTimers(context, startDate, endDate, selectedProjects);
    return const ListToCsvConverter(delimitAllFields: true).convert(
        _preprocessData(
            context, filteredTimers, _DurationFormat.decimal, false));
  }

  static Future<Document> toPDF(mat.BuildContext context, DateTime? startDate,
      DateTime endDate, List<Project?> selectedProjects) async {
    final localizations = L10N.of(context);

    final filteredTimers =
        _getFilteredTimers(context, startDate, endDate, selectedProjects);
    final data =
        _preprocessData(context, filteredTimers, _DurationFormat.time, true);
    final total = _getTotalTime(filteredTimers);

    final regularFont =
        Font.ttf(await rootBundle.load('fonts/PublicSans-Regular.ttf'));
    final boldFont =
        Font.ttf(await rootBundle.load('fonts/PublicSans-Bold.ttf'));

    final textStyleBody =
        TextStyle(fontWeight: FontWeight.normal, fontSize: 11); //12
    final textStyleBodyBold =
        textStyleBody.copyWith(fontWeight: FontWeight.bold);
    final textStyleBodySubtleBold = textStyleBody.copyWith(fontSize: 9); //10
    final textStyleBodySubtle =
        textStyleBodySubtleBold.copyWith(color: PdfColor.fromHex("#666666"));

    final textStyleH1 = textStyleBody.copyWith(fontSize: 18); //24
    final textStyleH2 = textStyleBodyBold.copyWith(fontSize: 14); //16

    final pdf = Document();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4, //TODO allow as setting
        orientation: PageOrientation.portrait, //TODO allow as setting
        theme: ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),
        build: (Context context) {
          return [
            Text(localizations.tr.summaryReport, style: textStyleH1),
            SizedBox(height: 2),
            Row(children: [
              if (startDate != null)
                Text(localizations.tr.dateRange, style: textStyleBodySubtle),
              if (startDate != null)
                Text(
                    " ${DateFormat.yMMMd().format(startDate)}–${DateFormat.yMMMd().format(endDate)}",
                    style: textStyleBodySubtleBold),
              if (startDate != null) SizedBox(width: 24),
              Text(localizations.tr.totalHours, style: textStyleBodySubtle),
              Text(" ${_formatDuration(total, _DurationFormat.both)}",
                  style: textStyleBodySubtleBold),
            ]),
            SizedBox(height: 18),
            Text(localizations.tr.timetable, style: textStyleH2),
            SizedBox(height: 6),
            TableHelper.fromTextArray(
                data: data,
                headerStyle: textStyleBodyBold,
                headerAlignment: AlignmentDirectional.bottomStart,
                cellAlignment: AlignmentDirectional.topStart,
                border: TableBorder.all(style: BorderStyle.none),
                cellPadding: const EdgeInsetsDirectional.only(end: 8)),
          ];
        }));
    return pdf;
  }
}
