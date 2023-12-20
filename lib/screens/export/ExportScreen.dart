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
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/project_description_pair.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/screens/export/components/ExportMenu.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class DayGroup {
  final DateTime date;
  List<TimerEntry> timers = [];

  DayGroup(this.date);
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Project?> selectedProjects = [];

  @override
  void initState() {
    super.initState();
    final projects = BlocProvider.of<ProjectsBloc>(context);
    selectedProjects = <Project?>[null]
        .followedBy(projects.state.projects
            .where((p) => !p.archived)
            .map((p) => Project.clone(p)))
        .toList();

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _startDate = settingsBloc.getFilterStartDate();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    final dateFormat = DateFormat.yMMMEd();
    final exportDateFormat = DateFormat.yMd();

    // TODO: break this into components or something so we don't have such a massively unmanagement build function

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.exportImport),
        actions: <Widget>[
          ExportMenu(dateFormat: dateFormat),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text(L10N.of(context).tr.filter,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700)),
            initiallyExpanded: true,
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesomeIcons.calendar),
                title: Text(L10N.of(context).tr.from),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  _startDate == null
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text("--"),
                        )
                      : Text(dateFormat.format(_startDate!)),
                  if (_startDate != null)
                    IconButton(
                      tooltip: L10N.of(context).tr.remove,
                      icon: const Icon(FontAwesomeIcons.circleMinus),
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                        });
                      },
                    )
                ]),
                onTap: () async {
                  await dt.DatePicker.showDatePicker(context,
                      currentTime: _startDate,
                      onChanged: (DateTime dt) => setState(() =>
                          _startDate = DateTime(dt.year, dt.month, dt.day)),
                      onConfirm: (DateTime dt) => setState(() =>
                          _startDate = DateTime(dt.year, dt.month, dt.day)),
                      theme: dt.DatePickerTheme(
                        cancelStyle: Theme.of(context).textTheme.labelLarge!,
                        doneStyle: Theme.of(context).textTheme.labelLarge!,
                        itemStyle: Theme.of(context).textTheme.bodyMedium!,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ));
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.calendar),
                title: Text(L10N.of(context).tr.to),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  _endDate == null
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text("--"),
                        )
                      : Text(dateFormat.format(_endDate!)),
                  if (_endDate != null)
                    IconButton(
                      tooltip: L10N.of(context).tr.remove,
                      icon: const Icon(FontAwesomeIcons.circleMinus),
                      onPressed: () {
                        setState(() {
                          _endDate = null;
                        });
                      },
                    )
                ]),
                onTap: () async {
                  await dt.DatePicker.showDatePicker(context,
                      currentTime: _endDate,
                      onChanged: (DateTime dt) => setState(() => _endDate =
                          DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                      onConfirm: (DateTime dt) => setState(() => _endDate =
                          DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                      theme: dt.DatePickerTheme(
                        cancelStyle: Theme.of(context).textTheme.labelLarge!,
                        doneStyle: Theme.of(context).textTheme.labelLarge!,
                        itemStyle: Theme.of(context).textTheme.bodyMedium!,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ));
                },
              ),
            ],
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            bloc: settingsBloc,
            builder: (BuildContext context, SettingsState settingsState) =>
                ExpansionTile(
              key: const Key("optionColumns"),
              title: Text(L10N.of(context).tr.columns,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700)),
              children: <Widget>[
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.date),
                  value: settingsState.exportIncludeDate,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeDate: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.project),
                  value: settingsState.exportIncludeProject,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeProject: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.description),
                  value: settingsState.exportIncludeDescription,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeDescription: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.combinedProjectDescription),
                  value: settingsState.exportIncludeProjectDescription,
                  onChanged: (bool value) => settingsBloc.add(SetBoolValueEvent(
                      exportIncludeProjectDescription: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.startTime),
                  value: settingsState.exportIncludeStartTime,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeStartTime: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.endTime),
                  value: settingsState.exportIncludeEndTime,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeEndTime: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.timeH),
                  value: settingsState.exportIncludeDurationHours,
                  onChanged: (bool value) => settingsBloc.add(
                      SetBoolValueEvent(exportIncludeDurationHours: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.notes),
                  value: settingsState.exportIncludeNotes,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportIncludeNotes: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text(L10N.of(context).tr.projects,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700)),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(L10N.of(context).tr.selectNone),
                    onPressed: () {
                      setState(() {
                        selectedProjects.clear();
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text(L10N.of(context).tr.selectAll),
                    onPressed: () {
                      setState(() {
                        selectedProjects = <Project?>[null]
                            .followedBy(projectsBloc.state.projects
                                .where((p) => !p.archived)
                                .map((p) => Project.clone(p)))
                            .toList();
                      });
                    },
                  ),
                ],
              )
            ]
                .followedBy(<Project?>[null]
                    .followedBy(
                        projectsBloc.state.projects.where((p) => !p.archived))
                    .map((project) => CheckboxListTile(
                          secondary: ProjectColour(
                            project: project,
                          ),
                          title: Text(
                              project?.name ?? L10N.of(context).tr.noProject),
                          value:
                              selectedProjects.any((p) => p?.id == project?.id),
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (_) => setState(() {
                            if (selectedProjects
                                .any((p) => p?.id == project?.id)) {
                              selectedProjects
                                  .removeWhere((p) => p?.id == project?.id);
                            } else {
                              selectedProjects.add(project);
                            }
                          }),
                        )))
                .toList(),
          ),
          ExpansionTile(
            title: Text(L10N.of(context).tr.options,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700)),
            children: <Widget>[
              BlocBuilder<SettingsBloc, SettingsState>(
                bloc: settingsBloc,
                builder: (BuildContext context, SettingsState settingsState) =>
                    SwitchListTile.adaptive(
                  title: Text(L10N.of(context).tr.groupTimers),
                  value: settingsState.exportGroupTimers,
                  onChanged: (bool value) => settingsBloc
                      .add(SetBoolValueEvent(exportGroupTimers: value)),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
        ].toList(),
      ),
      floatingActionButton: FloatingActionButton(
          key: const Key("exportFAB"),
          tooltip: L10N.of(context).tr.exportCSV,
          child: const Stack(
            // shenanigans to properly centre the icon (font awesome glyphs are variable
            // width but the library currently doesn't deal with that)
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 15,
                left: 19,
                child: Icon(FontAwesomeIcons.fileExport),
              )
            ],
          ),
          onPressed: () async {
            final timers = BlocProvider.of<TimersBloc>(context);
            final projects = BlocProvider.of<ProjectsBloc>(context);

            List<String> headers = [];
            if (settingsBloc.state.exportIncludeDate) {
              headers.add(L10N.of(context).tr.date);
            }
            if (settingsBloc.state.exportIncludeProject) {
              headers.add(L10N.of(context).tr.project);
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
            if (settingsBloc.state.exportIncludeNotes) {
              headers.add(L10N.of(context).tr.notes);
            }

            List<TimerEntry> filteredTimers = timers.state.timers
                .where((t) => t.endTime != null)
                .where((t) => selectedProjects.any((p) => p?.id == t.projectID))
                .where((t) => _startDate == null
                    ? true
                    : t.startTime.isAfter(_startDate!))
                .where((t) =>
                    _endDate == null ? true : t.endTime!.isBefore(_endDate!))
                .where((t) =>
                    !(projects.getProjectByID(t.projectID)?.archived == true))
                .toList();
            filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));

            // group similar timers if that's what you're in to
            if (settingsBloc.state.exportGroupTimers &&
                !(settingsBloc.state.exportIncludeStartTime ||
                    settingsBloc.state.exportIncludeEndTime)) {
              filteredTimers = timers.state.timers
                  .where((t) => t.endTime != null)
                  .where(
                      (t) => selectedProjects.any((p) => p?.id == t.projectID))
                  .where((t) => _startDate == null
                      ? true
                      : t.startTime.isAfter(_startDate!))
                  .where((t) =>
                      _endDate == null ? true : t.endTime!.isBefore(_endDate!))
                  .where((t) =>
                      !(projects.getProjectByID(t.projectID)?.archived == true))
                  .toList();
              filteredTimers.sort((a, b) => a.startTime.compareTo(b.startTime));

              // now start grouping those suckers
              final LinkedHashMap<String,
                      LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>>
                  derp = LinkedHashMap();
              for (TimerEntry timer in filteredTimers) {
                String date = exportDateFormat.format(timer.startTime);
                LinkedHashMap<ProjectDescriptionPair, List<TimerEntry>>
                    pairedEntries =
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
                return pairedEntries.values
                    .map((List<TimerEntry> groupedEntries) {
                  assert(groupedEntries.isNotEmpty);

                  // not a grouped entry
                  if (groupedEntries.length == 1) return groupedEntries[0];

                  // yes a group entry, build a dummy timer entry
                  Duration totalTime = groupedEntries.fold(
                      const Duration(),
                      (Duration d, TimerEntry t) =>
                          d + t.endTime!.difference(t.startTime));
                  return TimerEntry.clone(groupedEntries[0],
                      endTime: groupedEntries[0].startTime.add(totalTime));
                });
              }).toList();
            }

            final List<List<String>> data =
                <List<String>>[headers].followedBy(filteredTimers.map((timer) {
              List<String> row = [];
              if (settingsBloc.state.exportIncludeDate) {
                row.add(exportDateFormat.format(timer.startTime));
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
                row.add(timer.startTime.toUtc().toIso8601String());
              }
              if (settingsBloc.state.exportIncludeEndTime) {
                row.add(timer.endTime!.toUtc().toIso8601String());
              }
              if (settingsBloc.state.exportIncludeDurationHours) {
                row.add((timer.endTime!
                            .difference(timer.startTime)
                            .inSeconds
                            .toDouble() /
                        3600.0)
                    .toStringAsFixed(4));
              }
              if (settingsBloc.state.exportIncludeNotes) {
                row.add(timer.notes?.trim() ?? "");
              }
              return row;
            })).toList();
            final csv =
                const ListToCsvConverter(delimitAllFields: true).convert(data);

            final csvFilename =
                "timecop_${DateTime.now().toIso8601String().split('T').first}.csv";

            if (Platform.isMacOS || Platform.isLinux) {
              final outputFile = await FilePicker.platform.saveFile(
                dialogTitle: "",
                fileName: csvFilename,
              );

              if (outputFile != null) {
                await File(outputFile).writeAsString(csv, flush: true);
              }
            } else {
              final localizations = L10N.of(context);
              final directory = (Platform.isAndroid)
                  ? await getExternalStorageDirectory()
                  : await getApplicationDocumentsDirectory();
              final localPath = '${directory!.path}/$csvFilename';

              final file = File(localPath);
              await file.writeAsString(csv, flush: true);
              await Share.shareXFiles([XFile(localPath, mimeType: "text/csv")],
                  subject: localizations.tr
                      .timeCopEntries(dateFormat.format(DateTime.now())));
            }
          }),
    );
  }
}
