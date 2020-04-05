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
import 'package:timecop/data_providers/l10n/l10n_provider.dart';

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

  String get about => _bundle.format("about", errors: _errors);
  String get appDescription => _bundle.format("appDescription", errors: _errors);
  String get appLegalese => _bundle.format("appLegalese", errors: _errors);
  String get appName => _bundle.format("appName", errors: _errors);
  String get areYouSureYouWantToDelete => _bundle.format("areYouSureYouWantToDelete", errors: _errors);
  String get cancel => _bundle.format("cancel", errors: _errors);
  String get changeLog => _bundle.format("changeLog", errors: _errors);
  String get confirmDelete => _bundle.format("confirmDelete", errors: _errors);
  String get create => _bundle.format("create", errors: _errors);
  String get createNewProject => _bundle.format("createNewProject", errors: _errors);
  String get delete => _bundle.format("delete", errors: _errors);
  String get deleteTimerConfirm => _bundle.format("deleteTimerConfirm", errors: _errors);
  String get description => _bundle.format("description", errors: _errors);
  String get duration => _bundle.format("duration", errors: _errors);
  String get editProject => _bundle.format("editProject", errors: _errors);
  String get editTimer => _bundle.format("editTimer", errors: _errors);
  String get endTime => _bundle.format("endTime", errors: _errors);
  String get export => _bundle.format("export", errors: _errors);
  String get filter => _bundle.format("filter", errors: _errors);
  String get from => _bundle.format("from", errors: _errors);
  String get logoSemantics => _bundle.format("logoSemantics", errors: _errors);
  String get noProject => _bundle.format("noProject", errors: _errors);
  String get pleaseEnterAName => _bundle.format("pleaseEnterAName", errors: _errors);
  String get project => _bundle.format("project", errors: _errors);
  String get projectName => _bundle.format("projectName", errors: _errors);
  String get projects => _bundle.format("projects", errors: _errors);
  String get readme => _bundle.format("readme", errors: _errors);
  String get runningTimers => _bundle.format("runningTimers", errors: _errors);
  String get save => _bundle.format("save", errors: _errors);
  String get sourceCode => _bundle.format("sourceCode", errors: _errors);
  String get startTime => _bundle.format("startTime", errors: _errors);
  String get timeH => _bundle.format("timeH", errors: _errors);
  String get to => _bundle.format("to", errors: _errors);
  String get whatAreYouDoing => _bundle.format("whatAreYouDoing", errors: _errors);
  String get whatWereYouDoing => _bundle.format("whatWereYouDoing", errors: _errors);
  String get noDescription => _bundle.format("noDescription", errors: _errors);
  String timeCopDatabase(String date) => _bundle.format("timeCopDatabase", args: <String, dynamic>{"date": date}, errors: _errors);
  String timeCopEntries(String date) => _bundle.format("timeCopEntries", args: <String, dynamic>{"date": date}, errors: _errors);
  String get options => _bundle.format("options", errors: _errors);
  String get groupTimers => _bundle.format("groupTimers", errors: _errors);
  String get columns => _bundle.format("columns", errors: _errors);
  String get date => _bundle.format("date", errors: _errors);
  String get combinedProjectDescription => _bundle.format("combinedProjectDescription", errors: _errors);
  String get reports => _bundle.format("reports", errors: _errors) ?? "reports";
  String nHours(String hours) => _bundle.format("nHours", args: <String, dynamic>{"hours": hours}, errors: _errors);
  String get averageDailyHours => _bundle.format("averageDailyHours", errors: _errors) ?? "averageDailyHours";
  String get totalProjectShare => _bundle.format("totalProjectShare", errors: _errors) ?? "totalProjectShare";
  String get weeklyHours => _bundle.format("weeklyHours", errors: _errors) ?? "weeklyHours";
  String get contributors => _bundle.format("contributors", errors: _errors) ?? "contributors";
}