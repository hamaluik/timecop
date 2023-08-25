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

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';
import 'package:timecop/data_providers/data/database_provider.dart';
import 'package:timecop/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ExportMenuItem {
  import,
  export,
}

class ExportMenu extends StatelessWidget {
  final DateFormat? dateFormat;
  const ExportMenu({Key? key, this.dateFormat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExportMenuItem>(
      key: const Key("exportMenuButton"),
      icon: const Icon(FontAwesomeIcons.database),
      onSelected: (ExportMenuItem item) async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final theme = Theme.of(context);
        final localization = L10N.of(context);
        final settingsBloc = BlocProvider.of<SettingsBloc>(context);
        final timersBloc = BlocProvider.of<TimersBloc>(context);
        final projectsBloc = BlocProvider.of<ProjectsBloc>(context);

        switch (item) {
          case ExportMenuItem.import:
            try {
              final result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  allowMultiple: false,
                  withData: Platform.isLinux);
              if (result == null) {
                return;
              }

              final resultPath = Platform.isLinux
                  ? await _duplicateToTempDir(result.files.first.bytes!)
                  : result.files.first.path!;

              if (!await DatabaseProvider.isValidDatabaseFile(resultPath)) {
                scaffoldMessenger.showSnackBar(SnackBar(
                  backgroundColor: theme.colorScheme.error,
                  content: Text(
                    localization.tr.invalidDatabaseFile,
                    style: TextStyle(color: theme.colorScheme.onError),
                  ),
                  duration: const Duration(seconds: 5),
                ));
              } else {
                settingsBloc.add(
                    ImportDatabaseEvent(resultPath, timersBloc, projectsBloc));

                scaffoldMessenger.showSnackBar(SnackBar(
                  content: Text(localization.tr.databaseImported),
                  duration: const Duration(seconds: 5),
                ));
              }
            } catch (e) {
              if (e is PlatformException &&
                  e.code == "read_external_storage_denied") {
                scaffoldMessenger.showSnackBar(SnackBar(
                  content: Text(localization.tr.storageAccessRequired),
                  duration: const Duration(seconds: 5),
                ));
              } else {
                scaffoldMessenger.showSnackBar(SnackBar(
                  backgroundColor: theme.colorScheme.error,
                  content: Text(
                    e.toString(),
                    style: TextStyle(color: theme.colorScheme.onError),
                  ),
                  duration: const Duration(seconds: 5),
                ));
              }
            }
            break;
          case ExportMenuItem.export:
            final dbFile = await DatabaseProvider.getDatabaseFile();

            try {
              if (Platform.isMacOS || Platform.isLinux) {
                String? outputFile = await FilePicker.platform.saveFile(
                  dialogTitle: "",
                  fileName: "timecop.db",
                );

                if (outputFile != null) {
                  await dbFile.copy(outputFile);
                }
              } else {
                String dbPath = dbFile.path;
                if (Platform.isAndroid) {
                  // on android, copy it somewhere where it can be shared
                  final directory = await getExternalStorageDirectory();
                  if (directory != null) {
                    final copiedDB =
                        await dbFile.copy(p.join(directory.path, "timecop.db"));
                    dbPath = copiedDB.path;
                  }
                }
                await Share.shareXFiles(
                    [XFile(dbPath, mimeType: "application/vnd.sqlite3")],
                    subject: localization.tr
                        .timeCopDatabase(dateFormat!.format(DateTime.now())));
              }
            } on Exception catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(
                backgroundColor: theme.colorScheme.error,
                content: Text(
                  e.toString(),
                  style: TextStyle(color: theme.colorScheme.onError),
                ),
                duration: const Duration(seconds: 5),
              ));
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            key: const Key("exportMenuImport"),
            value: ExportMenuItem.import,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.fileImport),
              title: Text(L10N.of(context).tr.importDatabase),
            ),
          ),
          PopupMenuItem(
            key: const Key("exportMenuExport"),
            value: ExportMenuItem.export,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.fileExport),
              title: Text(L10N.of(context).tr.exportDatabase),
            ),
          ),
        ];
      },
    );
  }

  Future<String> _duplicateToTempDir(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = p.join(tempDir.path, 'timecop.db');
    await File(tempPath).writeAsBytes(bytes);
    return tempPath;
  }
}
