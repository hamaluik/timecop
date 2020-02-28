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

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:timecop/data_providers/l10n_provider.dart';

class JSONL10NProvider extends L10NProvider {
  Map<String, String> _translations;

  JSONL10NProvider._internal(this._translations)
    : assert(_translations != null);

  static Future<JSONL10NProvider> load(Locale locale) async {
    String jsonString = await rootBundle.loadString("l10n/${locale.languageCode}.json");
    dynamic rawJson = json.decode(jsonString);
    Map<String, dynamic> jsonMap = rawJson as Map<String, dynamic>;
    Map<String, String> strings = jsonMap.map((String key, dynamic value) => MapEntry(key, value.toString()));
    return JSONL10NProvider._internal(strings);
  }

  @override String get about => _translations['about'] ?? "-about-";
  @override String get appDescription => _translations['appDescription'] ?? "-appDescription-";
  @override String get appLegalese => _translations['appLegalese'] ?? "-appLegalese-";
  @override String get appName => _translations['appName'] ?? "-appName-";
  @override String get areYouSureYouWantToDeletePostfix => _translations['areYouSureYouWantToDeletePostfix'] ?? "-areYouSureYouWantToDeletePostfix-";
  @override String get areYouSureYouWantToDeletePrefix => _translations['areYouSureYouWantToDeletePrefix'] ?? "-areYouSureYouWantToDeletePrefix-";
  @override String get cancel => _translations['cancel'] ?? "-cancel-";
  @override String get changeLog => _translations['changeLog'] ?? "-changeLog-";
  @override String get confirmDelete => _translations['confirmDelete'] ?? "-confirmDelete-";
  @override String get create => _translations['create'] ?? "-create-";
  @override String get createNewProject => _translations['createNewProject'] ?? "-createNewProject-";
  @override String get delete => _translations['delete'] ?? "-delete-";
  @override String get deleteTimerConfirm => _translations['deleteTimerConfirm'] ?? "-deleteTimerConfirm-";
  @override String get description => _translations['description'] ?? "-description-";
  @override String get duration => _translations['duration'] ?? "-duration-";
  @override String get editProject => _translations['editProject'] ?? "-editProject-";
  @override String get editTimer => _translations['editTimer'] ?? "-editTimer-";
  @override String get endTime => _translations['endTime'] ?? "-endTime-";
  @override String get export => _translations['export'] ?? "-export-";
  @override String get filter => _translations['filter'] ?? "-filter-";
  @override String get from => _translations['from'] ?? "-from-";
  @override String get includeProjects => _translations['includeProjects'] ?? "-includeProjects-";
  @override String get logoSemantics => _translations['logoSemantics'] ?? "-logoSemantics-";
  @override String get noDescription => _translations['noDescription'] ?? "-noDescription-";
  @override String get noProject => _translations['noProject'] ?? "-noProject-";
  @override String get pleaseEnterAName => _translations['pleaseEnterAName'] ?? "-pleaseEnterAName-";
  @override String get project => _translations['project'] ?? "-project-";
  @override String get projectName => _translations['projectName'] ?? "-projectName-";
  @override String get projects => _translations['projects'] ?? "-projects-";
  @override String get readme => _translations['readme'] ?? "-readme-";
  @override String get runningTimers => _translations['runningTimers'] ?? "-runningTimers-";
  @override String get save => _translations['save'] ?? "-save-";
  @override String get sourceCode => _translations['sourceCode'] ?? "-sourceCode-";
  @override String get startTime => _translations['startTime'] ?? "-startTime-";
  @override String get timeH => _translations['timeH'] ?? "-timeH-";
  @override String get to => _translations['to'] ?? "-to-";
  @override String get whatAreYouDoing => _translations['whatAreYouDoing'] ?? "-whatAreYouDoing-";
  @override String get whatWereYouDoing => _translations['whatWereYouDoing'] ?? "-whatWereYouDoing-";
  @override String timeCopDatabase(String date) => _translations['timeCopDatabase']?.replaceAll(r"{date}", date) ?? "-timeCopDatabase-";
  @override String timeCopEntries(String date) => _translations['timeCopEntries']?.replaceAll(r"{date}", date) ?? "-timeCopEntries-";
}