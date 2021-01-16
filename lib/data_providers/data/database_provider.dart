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
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/models/timer_entry.dart';
import 'package:timecop/models/project.dart';

class DatabaseProvider extends DataProvider {
  final Database _db;
  final RandomColor _randomColour = RandomColor();
  static const int DB_VERSION = 4;

  DatabaseProvider(this._db) : assert(_db != null);

  void close() async {
    await _db.close();
  }

  static void _onConfigure(Database db) async {
    // don't turn foreign keys on here as the onCreate / onUpgrade / onDowngrade
    // procedures happen inside a transaction, and we can't disable keys in
    // a transaction. Soooo... do it manually I guess when we open the database
    //await db.execute("PRAGMA foreign_keys = ON");
    await db.execute("PRAGMA foreign_keys = OFF");
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      create table if not exists projects(
        id integer not null primary key autoincrement,
        name text not null,
        colour int not null,
        archived boolean not null default 0
      )
    ''');
    await db.execute('''
      create table if not exists timers(
        id integer not null primary key autoincrement,
        project_id integer default null,
        description text not null,
        start_time int not null,
        end_time int default null,
        notes text default null,
        foreign key(project_id) references projects(id) on delete set null
      )
    ''');
    await db.execute('''
      create index if not exists timers_start_time on timers(start_time)
    ''');
  }

  static void _onUpgrade(Database db, int version, int newVersion) async {
    if (version < 2) {
      await db.execute('''
              alter table projects add column archived boolean not null default false
            ''');
    }
    if (version < 3) {
      await db.execute('''
              alter table timers add column notes text default null
            ''');
    }
    if (version < 4) {
      // fix the bug of the default value being `false` for project archives instead of `0`.
      // `false` works fine on sqlite >= 3.23.0. Unfortunately, some Android phones still have
      // ancient sqlite versions, so to them `false` is a string rather than an integer with
      // value `0`
      Batch b = db.batch();
      b.execute('''
            create table projects_tmp(
                id integer not null primary key autoincrement,
                name text not null,
                colour int not null,
                archived boolean not null default 0
            )
            ''');
      b.execute("insert into projects_tmp select * from projects");
      b.execute("drop table projects");
      b.execute('''
            create table projects(
                id integer not null primary key autoincrement,
                name text not null,
                colour int not null,
                archived boolean not null default 0
            )
        ''');
      b.execute('''
            insert into projects select id, name, colour,
                case archived
                    when 'false' then 0
                    when 'true' then 1
                    when '0' then 0
                    when '1' then 1
                    when 0 then 0
                    when 1 then 1
                    else 0
                end as archived
                from projects_tmp
        ''');
      b.execute("drop table projects_tmp");
      await b.commit(noResult: true);
    }
  }

  static Future<DatabaseProvider> open(String path) async {
    // open the database
    Database db = await openDatabase(path,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        version: DB_VERSION);
    await db.execute("PRAGMA foreign_keys = ON");
    DatabaseProvider repo = DatabaseProvider(db);

    return repo;
  }

  /// the c in crud
  @override
  Future<Project> createProject(
      {@required String name, Color colour, bool archived}) async {
    assert(name != null);
    colour ??= _randomColour.randomColor();
    archived ??= false;

    int id = await _db.rawInsert(
        "insert into projects(name, colour, archived) values(?, ?, ?)",
        <dynamic>[name, colour.value, archived ? 1 : 0]);
    return Project(id: id, name: name, colour: colour, archived: archived);
  }

  /// the r in crud
  @override
  Future<List<Project>> listProjects() async {
    List<Map<String, dynamic>> rawProjects = await _db.rawQuery('''
        select id, name, colour, 
            case archived
                when 'false' then 0
                when 'true' then 1
                when '0' then 0
                when '1' then 1
                when 0 then 0
                when 1 then 1
                else 0
            end as archived
        from projects order by name asc
    ''');
    return rawProjects
        .map((Map<String, dynamic> row) => Project(
            id: row["id"] as int,
            name: row["name"] as String,
            colour: Color(row["colour"] as int),
            archived: (row["archived"] as int) == 1))
        .toList();
  }

  /// the u in crud
  @override
  Future<void> editProject(Project project) async {
    assert(project != null);
    int rows = await _db.rawUpdate(
        "update projects set name=?, colour=?, archived=? where id=?",
        <dynamic>[
          project.name,
          project.colour.value,
          project.archived ? 1 : 0,
          project.id
        ]);
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
      DateTime endTime,
      String notes}) async {
    int st = startTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;
    assert(st != null);
    int et = endTime?.millisecondsSinceEpoch;
    int id = await _db.rawInsert(
        "insert into timers(project_id, description, start_time, end_time, notes) values(?, ?, ?, ?, ?)",
        <dynamic>[projectID, description, st, et, notes]);
    return TimerEntry(
        id: id,
        description: description,
        projectID: projectID,
        startTime: DateTime.fromMillisecondsSinceEpoch(st),
        endTime: endTime,
        notes: notes);
  }

  /// the r in crud
  @override
  Future<List<TimerEntry>> listTimers() async {
    List<Map<String, dynamic>> rawTimers = await _db.rawQuery(
        "select id, project_id, description, start_time, end_time, notes from timers order by start_time asc");
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
            notes: row["notes"] as String))
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
        "update timers set project_id=?, description=?, start_time=?, end_time=?, notes=? where id=?",
        <dynamic>[
          timer.projectID,
          timer.description,
          st,
          et,
          timer.notes,
          timer.id
        ]);
  }

  /// the d in crud
  @override
  Future<void> deleteTimer(TimerEntry timer) async {
    assert(timer != null);
    await _db.rawDelete("delete from timers where id=?", <dynamic>[timer.id]);
  }

  static Future<bool> isValidDatabaseFile(String path) async {
    try {
      Database db = await openDatabase(path, readOnly: true);
      await db.rawQuery(
          "select id, name, colour, archived from projects order by name asc limit 1");
      await db.rawQuery(
          "select id, project_id, description, start_time, end_time, notes from timers order by start_time asc limit 1");
      await db.close();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
