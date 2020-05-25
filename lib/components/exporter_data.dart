import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/project.dart';

class ExporterData {
  DateTime startDate;
  DateTime endDate;
  List<Project> selectedProjects = [];
  List<WorkType> selectedWorkTypes = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final DateFormat dateFormat = DateFormat("EE, MMM d, yyyy");
  static final DateFormat dateTimeFormat =
      DateFormat("EE, MMM d, yyyy HH_mm_s");
}
