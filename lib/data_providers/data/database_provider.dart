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

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:random_color/random_color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/project.dart';

class DatabaseProvider extends DataProvider {
  final Database _db;
  final RandomColor _randomColour = RandomColor();
  static const int DB_VERSION = 1;

  DatabaseProvider(this._db) : assert(_db != null);

  static void _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      create table projects(
        id integer not null primary key autoincrement,
        name text not null,
        colour int not null
      )
    ''');
    await db.execute('''
      create table timers(
        id integer not null primary key autoincrement,
        project_id integer default null,
        description text not null,
        start_time int not null,
        end_time int default null,
        foreign key(project_id) references projects(id) on delete set null
      )
    ''');
    await db.execute('''
      create index if not exists timers_start_time on timers(start_time)
    ''');
  }

  static Future<DatabaseProvider> open() async {
    // get a path to the database file
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, 'timecop.db');
    await Directory(databasesPath).create(recursive: true);

    // open the database
    Database db = await openDatabase(path,
        onConfigure: _onConfigure, onCreate: _onCreate, version: DB_VERSION);
    DatabaseProvider repo = DatabaseProvider(db);

    return repo;
  }

  /// the c in crud
  @override
  Future<Project> createProject({@required String name, Color colour}) async {
    assert(name != null);
    colour ??= _randomColour.randomColor();

    int id = await _db.rawInsert(
        "insert into projects(name, colour) values(?, ?)",
        <dynamic>[name, colour.value]);
    return Project(id: id, name: name, colour: colour);
  }

  /// the r in crud
  @override
  Future<List<Project>> listProjects() async {
    List<Map<String, dynamic>> rawProjects = await _db
        .rawQuery("select id, name, colour from projects order by name asc");
    return rawProjects
        .map((Map<String, dynamic> row) => Project(
            id: row["id"] as int,
            name: row["name"] as String,
            colour: Color(row["colour"] as int)))
        .toList();
  }

  /// the u in crud
  @override
  Future<void> editProject(Project project) async {
    assert(project != null);
    int rows = await _db.rawUpdate(
        "update projects set name=?, colour=? where id=?",
        <dynamic>[project.name, project.colour.value, project.id]);
    assert(rows == 1);
  }

  /// the d in crud
  @override
  Future<void> deleteProject(Project project) async {
    assert(project != null);
    await _db
        .rawDelete("delete from projects where id=?", <dynamic>[project.id]);
  }

  /// the c in crud
  @override
  Future<TimerEntry> createTimer(
      {String description,
      int projectID,
      DateTime startTime,
      DateTime endTime}) async {
    int st = startTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;
    assert(st != null);
    int et = endTime?.millisecondsSinceEpoch;
    int id = await _db.rawInsert(
        "insert into timers(project_id, description, start_time, end_time) values(?, ?, ?, ?)",
        <dynamic>[projectID, description, st, et]);
    return TimerEntry(
        id: id,
        description: description,
        projectID: projectID,
        startTime: DateTime.fromMillisecondsSinceEpoch(st),
        endTime: endTime);
  }

  /// the r in crud
  @override
  Future<List<TimerEntry>> listTimers() async {
    List<Map<String, dynamic>> rawTimers = await _db.rawQuery(
        "select id, project_id, description, start_time, end_time from timers order by start_time asc");
    return rawTimers
        .map((Map<String, dynamic> row) => TimerEntry(
              id: row["id"] as int,
              projectID: row["project_id"] as int,
              description: row["description"] as String,
              startTime:
                  DateTime.fromMillisecondsSinceEpoch(row["start_time"] as int),
              endTime: row["end_time"] != null
                  ? DateTime.fromMillisecondsSinceEpoch(row["end_time"] as int)
                  : null,
            ))
        .toList();
  }

  /// the u in crud
  @override
  Future<void> editTimer(TimerEntry timer) async {
    assert(timer != null);
    int st = timer.startTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;
    int et = timer.endTime?.millisecondsSinceEpoch;
    await _db.rawUpdate(
        "update timers set project_id=?, description=?, start_time=?, end_time=? where id=?",
        <dynamic>[timer.projectID, timer.description, st, et, timer.id]);
  }

  /// the d in crud
  @override
  Future<void> deleteTimer(TimerEntry timer) async {
    assert(timer != null);
    await _db.rawDelete("delete from timers where id=?", <dynamic>[timer.id]);
  }
}
