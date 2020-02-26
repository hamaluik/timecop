import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:timecop/models/log_entry.dart';
import 'package:timecop/models/project.dart';

class DatabaseProvider {
  final Database _db;

  DatabaseProvider(this._db) : assert(_db != null);

  static void _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      create table projects(
        id integer not null primary key autoincrement,
        name text not null
      )
    ''');
    await db.execute('''
      create table log_entries(
        id integer not null primary key autoincrement,
        project_id integer default null,
        description text not null,
        start_time text not null,
        end_time text default null,
        foreign key(project_id) references projects(id)
      )
    ''');
  }

  static Future<DatabaseProvider> open() async {
    // get a path to the database file
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, 'timecop.db');
    await Directory(databasesPath).create(recursive: true);

    // open the database
    Database db = await openDatabase(path,
        onConfigure: _onConfigure, onCreate: _onCreate, version: 1);
    DatabaseProvider repo = DatabaseProvider(db);

    return repo;
  }

  Future<int> insertProject(Project project) async {
    throw Exception("unimplemented");
  }

  Future<int> insertLogEntry(LogEntry entry) async {
    throw Exception("unimplemented");
  }
}
