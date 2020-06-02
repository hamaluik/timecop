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

import 'package:flutter/widgets.dart';

abstract class L10NProvider {
  String get about;
  String get appDescription;
  String get appLegalese;
  String get appName;
  String get areYouSureYouWantToDelete;
  String get cancel;
  String get changeLog;
  String get confirmDelete;
  String get create;
  String get createNewProject;
  String get delete;
  String get deleteTimerConfirm;
  String get description;
  String get duration;
  String get editProject;
  String get editTimer;
  String get endTime;
  String get export;
  String get filter;
  String get from;
  String get logoSemantics;
  String get noProject;
  String get pleaseEnterAName;
  String get project;
  String get projectName;
  String get projects;
  String get readme;
  String get runningTimers;
  String get save;
  String get sourceCode;
  String get startTime;
  String get timeH;
  String get to;
  String get whatAreYouDoing;
  String get whatWereYouDoing;
  String get noDescription;
  String timeCopDatabase(String date);
  String timeCopEntries(String date);
  String get options;
  String get groupTimers;
  String get columns;
  String get date;
  String get combinedProjectDescription;
  String get reports;
  String nHours(String hours);
  String get averageDailyHours;
  String get totalProjectShare;
  String get weeklyHours;
  String get contributors;
  String get settings;
  String get theme;
  String get auto;
  String get light;
  String get dark;
  String get black;
  String langName(Locale locale);
  String get language;
  String get automaticLanguage;
  String get collapseDays;
  String get autocompleteDescription;
  String get defaultFilterStartDateToMonday;
  String get hours;
  String get total;
  String get oneTimerAtATime;
  String get selectAll;
  String get selectNone;
}
