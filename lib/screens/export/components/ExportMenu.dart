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
import 'package:path/path.dart' as p;
import 'package:flutter_share/flutter_share.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timecop/l10n.dart';

enum ExportMenuItem {
  import,
  export,
}

class ExportMenu extends StatelessWidget {
  final DateFormat dateFormat;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ExportMenu({Key key, this.dateFormat, this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExportMenuItem>(
      key: Key("exportMenuButton"),
      icon: Icon(FontAwesomeIcons.database),
      onSelected: (ExportMenuItem item) async {
        switch (item) {
          case ExportMenuItem.import:
            break;
          case ExportMenuItem.export:
            var databasesPath = await getDatabasesPath();
            var dbPath = p.join(databasesPath, 'timecop.db');

            try {
              // on android, copy it somewhere where it can be shared
              if (Platform.isAndroid) {
                Directory directory = await getExternalStorageDirectory();
                File copiedDB = await File(dbPath)
                    .copy(p.join(directory.path, "timecop.db"));
                dbPath = copiedDB.path;
              }
              await FlutterShare.shareFile(
                  title: L10N
                      .of(context)
                      .tr
                      .timeCopDatabase(dateFormat.format(DateTime.now())),
                  filePath: dbPath);
            } on Exception catch (e) {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                  e.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 5),
              ));
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            key: Key("exportMenuImport"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.fileImport),
              title: Text(L10N.of(context).tr.import),
            ),
            value: ExportMenuItem.import,
          ),
          PopupMenuItem(
            key: Key("exportMenuExport"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.fileExport),
              title: Text(L10N.of(context).tr.export),
            ),
            value: ExportMenuItem.export,
          ),
        ];
      },
    );
  }
}
