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

import 'package:fluent/fluent.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:timecop/data_providers/l10n_provider.dart';

class FluentL10NProvider extends L10NProvider {
  final FluentBundle _bundle;
  List<Error> _errors = [];

  FluentL10NProvider._internal(this._bundle)
    : assert(_bundle != null);

  static Future<FluentL10NProvider> load(Locale locale) async {
    final FluentBundle bundle = FluentBundle(locale.toLanguageTag());
    
    String src = "l10n/${locale.languageCode}.flt";
    // special handling of zh-CN & zh-TW for now
    if(locale.languageCode == "zh" && locale.countryCode == "CN") {
      src = "l10n/zh-CN.flt";
    }
    else if(locale.languageCode == "zh" && locale.countryCode == "TW") {
      src = "l10n/zh-TW.flt";
    }
    String messages = await rootBundle.loadString(src);
    bundle.addMessages(messages);

    return FluentL10NProvider._internal(bundle);
  }

  String get about => _bundle.format("about", errors: _errors) ?? "about";
  String get appDescription => _bundle.format("appDescription", errors: _errors) ?? "appDescription";
  String get appLegalese => _bundle.format("appLegalese", errors: _errors) ?? "appLegalese";
  String get appName => _bundle.format("appName", errors: _errors) ?? "appName";
  String get areYouSureYouWantToDelete => _bundle.format("areYouSureYouWantToDelete", errors: _errors) ?? "areYouSureYouWantToDelete";
  String get cancel => _bundle.format("cancel", errors: _errors) ?? "cancel";
  String get changeLog => _bundle.format("changeLog", errors: _errors) ?? "changeLog";
  String get confirmDelete => _bundle.format("confirmDelete", errors: _errors) ?? "confirmDelete";
  String get create => _bundle.format("create", errors: _errors) ?? "create";
  String get createNewProject => _bundle.format("createNewProject", errors: _errors) ?? "createNewProject";
  String get delete => _bundle.format("delete", errors: _errors) ?? "delete";
  String get deleteTimerConfirm => _bundle.format("deleteTimerConfirm", errors: _errors) ?? "deleteTimerConfirm";
  String get description => _bundle.format("description", errors: _errors) ?? "description";
  String get duration => _bundle.format("duration", errors: _errors) ?? "duration";
  String get editProject => _bundle.format("editProject", errors: _errors) ?? "editProject";
  String get editTimer => _bundle.format("editTimer", errors: _errors) ?? "editTimer";
  String get endTime => _bundle.format("endTime", errors: _errors) ?? "endTime";
  String get export => _bundle.format("export", errors: _errors) ?? "export";
  String get filter => _bundle.format("filter", errors: _errors) ?? "filter";
  String get from => _bundle.format("from", errors: _errors) ?? "from";
  String get includeProjects => _bundle.format("includeProjects", errors: _errors) ?? "includeProjects";
  String get logoSemantics => _bundle.format("logoSemantics", errors: _errors) ?? "logoSemantics";
  String get noProject => _bundle.format("noProject", errors: _errors) ?? "noProject";
  String get pleaseEnterAName => _bundle.format("pleaseEnterAName", errors: _errors) ?? "pleaseEnterAName";
  String get project => _bundle.format("project", errors: _errors) ?? "project";
  String get projectName => _bundle.format("projectName", errors: _errors) ?? "projectName";
  String get projects => _bundle.format("projects", errors: _errors) ?? "projects";
  String get readme => _bundle.format("readme", errors: _errors) ?? "readme";
  String get runningTimers => _bundle.format("runningTimers", errors: _errors) ?? "runningTimers";
  String get save => _bundle.format("save", errors: _errors) ?? "save";
  String get sourceCode => _bundle.format("sourceCode", errors: _errors) ?? "sourceCode";
  String get startTime => _bundle.format("startTime", errors: _errors) ?? "startTime";
  String get timeH => _bundle.format("timeH", errors: _errors) ?? "timeH";
  String get to => _bundle.format("to", errors: _errors) ?? "to";
  String get whatAreYouDoing => _bundle.format("whatAreYouDoing", errors: _errors) ?? "whatAreYouDoing";
  String get whatWereYouDoing => _bundle.format("whatWereYouDoing", errors: _errors) ?? "whatWereYouDoing";
  String get noDescription => _bundle.format("noDescription", errors: _errors) ?? "noDescription";
  String timeCopDatabase(String date) => _bundle.format("timeCopDatabase", args: <String, dynamic>{"date": date}, errors: _errors) ?? "timeCopDatabase";
  String timeCopEntries(String date) => _bundle.format("timeCopEntries", args: <String, dynamic>{"date": date}, errors: _errors) ?? "timeCopEntries";
  String get options => _bundle.format("options", errors: _errors) ?? "options";
  String get groupTimers => _bundle.format("groupTimers", errors: _errors) ?? "groupTimers";
  String get columns => _bundle.format("columns", errors: _errors) ?? "columns";
  String get date => _bundle.format("date", errors: _errors) ?? "date";
  String get combinedProjectDescription => _bundle.format("combinedProjectDescription", errors: _errors) ?? "combinedProjectDescription";
  String get reports => _bundle.format("reports", errors: _errors) ?? "reports";
}