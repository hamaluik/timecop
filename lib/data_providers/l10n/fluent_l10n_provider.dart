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
  final List<Error> _errors = [];

  FluentL10NProvider._internal(this._bundle);

  static Future<FluentL10NProvider> load(Locale locale) async {
    final FluentBundle bundle = FluentBundle(locale.toLanguageTag());

    String src = "l10n/${locale.languageCode}.flt";
    // special handling of zh-CN, zh-TW & nb-NO for now
    switch (locale.languageCode) {
      case "zh":
        switch (locale.countryCode) {
          case "TW":
            src = "l10n/zh-TW.flt";
            break;
          default:
            src = "l10n/zh-CN.flt";
            break;
        }
        break;
      case "nb":
        src = "l10n/nb-NO.flt";
        break;
    }

    String messages = await rootBundle.loadString(src);
    bundle.addMessages(messages);

    return FluentL10NProvider._internal(bundle);
  }

  @override
  String get about => _bundle.format("about", errors: _errors) ?? "about";
  @override
  String get appDescription =>
      _bundle.format("appDescription", errors: _errors) ?? "appDescription";
  @override
  String get appLegalese =>
      _bundle.format("appLegalese", errors: _errors) ?? "appLegalese";
  @override
  String get appName => _bundle.format("appName", errors: _errors) ?? "appName";
  @override
  String get areYouSureYouWantToDelete =>
      _bundle.format("areYouSureYouWantToDelete", errors: _errors) ??
      "areYouSureYouWantToDelete";
  @override
  String get cancel => _bundle.format("cancel", errors: _errors) ?? "cancel";
  @override
  String get ok => _bundle.format("ok", errors: _errors) ?? "ok";
  @override
  String get changeLog =>
      _bundle.format("changeLog", errors: _errors) ?? "changeLog";
  @override
  String get confirmDelete =>
      _bundle.format("confirmDelete", errors: _errors) ?? "confirmDelete";
  @override
  String get create => _bundle.format("create", errors: _errors) ?? "create";
  @override
  String get createNewProject =>
      _bundle.format("createNewProject", errors: _errors) ?? "createNewProject";
  @override
  String get delete => _bundle.format("delete", errors: _errors) ?? "delete";
  @override
  String get deleteTimerConfirm =>
      _bundle.format("deleteTimerConfirm", errors: _errors) ??
      "deleteTimerConfirm";
  @override
  String get remove => _bundle.format("remove", errors: _errors) ?? "remove";
  @override
  String get stopTimer =>
      _bundle.format("stopTimer", errors: _errors) ?? "stopTimer";
  @override
  String get resumeTimer =>
      _bundle.format("resumeTimer", errors: _errors) ?? "resumeTimer";
  @override
  String get description =>
      _bundle.format("description", errors: _errors) ?? "description";
  @override
  String get duration =>
      _bundle.format("duration", errors: _errors) ?? "duration";
  @override
  String get editProject =>
      _bundle.format("editProject", errors: _errors) ?? "editProject";
  @override
  String get editTimer =>
      _bundle.format("editTimer", errors: _errors) ?? "editTimer";
  @override
  String get endTime => _bundle.format("endTime", errors: _errors) ?? "endTime";
  @override
  String get exportImport =>
      _bundle.format("exportImport", errors: _errors) ?? "exportImport";
  @override
  String get exportCSV =>
      _bundle.format("exportCSV", errors: _errors) ?? "exportCSV";
  @override
  String get exportDatabase =>
      _bundle.format("exportDatabase", errors: _errors) ?? "exportDatabase";
  @override
  String get importDatabase =>
      _bundle.format("importDatabase", errors: _errors) ?? "importDatabase";
  @override
  String get filter => _bundle.format("filter", errors: _errors) ?? "filter";
  @override
  String get from => _bundle.format("from", errors: _errors) ?? "from";
  @override
  String get logoSemantics =>
      _bundle.format("logoSemantics", errors: _errors) ?? "logoSemantics";
  @override
  String get noProject =>
      _bundle.format("noProject", errors: _errors) ?? "noProject";
  @override
  String get pleaseEnterAName =>
      _bundle.format("pleaseEnterAName", errors: _errors) ?? "pleaseEnterAName";
  @override
  String get project => _bundle.format("project", errors: _errors) ?? "project";
  @override
  String get projectName =>
      _bundle.format("projectName", errors: _errors) ?? "projectName";
  @override
  String get projects =>
      _bundle.format("projects", errors: _errors) ?? "projects";
  @override
  String get readme => _bundle.format("readme", errors: _errors) ?? "readme";
  @override
  String get runningTimers =>
      _bundle.format("runningTimers", errors: _errors) ?? "runningTimers";
  @override
  String get save => _bundle.format("save", errors: _errors) ?? "save";
  @override
  String get sourceCode =>
      _bundle.format("sourceCode", errors: _errors) ?? "sourceCode";
  @override
  String get translate =>
      _bundle.format("translate", errors: _errors) ?? "translate";
  @override
  String get startTime =>
      _bundle.format("startTime", errors: _errors) ?? "startTime";
  @override
  String get timeH => _bundle.format("timeH", errors: _errors) ?? "timeH";
  @override
  String get to => _bundle.format("to", errors: _errors) ?? "to";
  @override
  String get whatAreYouDoing =>
      _bundle.format("whatAreYouDoing", errors: _errors) ?? "whatAreYouDoing";
  @override
  String get whatWereYouDoing =>
      _bundle.format("whatWereYouDoing", errors: _errors) ?? "whatWereYouDoing";
  @override
  String get noDescription =>
      _bundle.format("noDescription", errors: _errors) ?? "noDescription";
  @override
  String get archive => _bundle.format("archive", errors: _errors) ?? "archive";
  @override
  String get unarchive =>
      _bundle.format("unarchive", errors: _errors) ?? "unarchive";
  @override
  String get startTimer =>
      _bundle.format("startTimer", errors: _errors) ?? "startTimer";
  @override
  String get stopAllTimers =>
      _bundle.format("stopAllTimers", errors: _errors) ?? "stopAllTimers";
  @override
  String get startNewTimer =>
      _bundle.format("startNewTimer", errors: _errors) ?? "startNewTimer";
  @override
  String get timerMenu =>
      _bundle.format("timerMenu", errors: _errors) ?? "timerMenu";
  @override
  String get closeMenu =>
      _bundle.format("closeMenu", errors: _errors) ?? "closeMenu";
  @override
  String get search => _bundle.format("search", errors: _errors) ?? "search";
  @override
  String get setToCurrentTime =>
      _bundle.format("setToCurrentTime", errors: _errors) ?? "setToCurrentTime";
  @override
  String timeCopDatabase(String date) =>
      _bundle.format("timeCopDatabase",
          args: <String, dynamic>{"date": date}, errors: _errors) ??
      "timeCopDatabase";
  @override
  String timeCopEntries(String date) =>
      _bundle.format("timeCopEntries",
          args: <String, dynamic>{"date": date}, errors: _errors) ??
      "timeCopEntries";
  @override
  String get options => _bundle.format("options", errors: _errors) ?? "options";
  @override
  String get groupTimers =>
      _bundle.format("groupTimers", errors: _errors) ?? "groupTimers";
  @override
  String get columns => _bundle.format("columns", errors: _errors) ?? "columns";
  @override
  String get date => _bundle.format("date", errors: _errors) ?? "date";
  @override
  String get combinedProjectDescription =>
      _bundle.format("combinedProjectDescription", errors: _errors) ??
      "combinedProjectDescription";
  @override
  String get reports => _bundle.format("reports", errors: _errors) ?? "reports";
  @override
  String nHours(String hours) =>
      _bundle.format("nHours",
          args: <String, dynamic>{"hours": hours}, errors: _errors) ??
      "nHours";
  @override
  String get averageDailyHours =>
      _bundle.format("averageDailyHours", errors: _errors) ??
      "averageDailyHours";
  @override
  String get totalProjectShare =>
      _bundle.format("totalProjectShare", errors: _errors) ??
      "totalProjectShare";
  @override
  String get weeklyHours =>
      _bundle.format("weeklyHours", errors: _errors) ?? "weeklyHours";
  @override
  String get contributors =>
      _bundle.format("contributors", errors: _errors) ?? "contributors";
  @override
  String get settings =>
      _bundle.format("settings", errors: _errors) ?? "settings";
  @override
  String get theme => _bundle.format("theme", errors: _errors) ?? "theme";
  @override
  String get auto => _bundle.format("auto", errors: _errors) ?? "auto";
  @override
  String get light => _bundle.format("light", errors: _errors) ?? "light";
  @override
  String get dark => _bundle.format("dark", errors: _errors) ?? "dark";
  @override
  String get black => _bundle.format("black", errors: _errors) ?? "black";
  @override
  String get autoMaterialYou =>
      _bundle.format("autoMaterialYou", errors: _errors) ?? "autoMaterialYou";
  @override
  String get lightMaterialYou =>
      _bundle.format("lightMaterialYou", errors: _errors) ?? "lightMaterialYou";
  @override
  String get darkMaterialYou =>
      _bundle.format("darkMaterialYou", errors: _errors) ?? "darkMaterialYou";
  @override
  String get showProjectNames =>
      _bundle.format("showProjectNames", errors: _errors) ?? "showProjectNames";
  @override
  String get nagAboutMissingTimer =>
      _bundle.format("nagAboutMissingTimer", errors: _errors) ??
      "nagAboutMissingTimer";
  @override
  String langName(Locale locale) {
    switch (locale.languageCode) {
      case "ar":
        return "العربية";
      case "cs":
        return "Čeština";
      case "da":
        return "Dansk";
      case "de":
        return "Deutsch";
      case "en":
        return "English";
      case "es":
        return "Español";
      case "fr":
        return "Français";
      case "hi":
        return "हिन्दी";
      case "id":
        return "Indonesia";
      case "it":
        return "Italiano";
      case "ja":
        return "日本語";
      case "ko":
        return "한국어";
      case "nb":
        return "Norsk Bokmål";
      case "pt":
        return "Português";
      case "ru":
        return "русский";
      case "tr":
        return "Türk";
      case "zh":
        {
          switch (locale.countryCode) {
            case "CN":
              return "中文（简体）";
            case "TW":
              return "中文（繁體）";
            default:
              return "中文";
          }
        }
    }
    return "<lang name>";
  }

  @override
  String get language =>
      _bundle.format("language", errors: _errors) ?? "language";

  @override
  String get automaticLanguage =>
      _bundle.format("automaticLanguage", errors: _errors) ??
      "automaticLanguage";

  @override
  String get collapseDays =>
      _bundle.format("collapseDays", errors: _errors) ?? "collapseDays";
  @override
  String get autocompleteDescription =>
      _bundle.format("autocompleteDescription", errors: _errors) ??
      "autocompleteDescription";
  @override
  String get defaultFilterStartDateToMonday =>
      _bundle.format("defaultFilterStartDateToMonday", errors: _errors) ??
      "defaultFilterStartDateToMonday";
  @override
  String get hours => _bundle.format("hours", errors: _errors) ?? "hours";
  @override
  String get total => _bundle.format("total", errors: _errors) ?? "total";
  @override
  String get oneTimerAtATime =>
      _bundle.format("oneTimerAtATime", errors: _errors) ?? "oneTimerAtATime";
  @override
  String get selectAll =>
      _bundle.format("selectAll", errors: _errors) ?? "selectAll";
  @override
  String get selectNone =>
      _bundle.format("selectNone", errors: _errors) ?? "selectNone";
  @override
  String get showBadgeCounts =>
      _bundle.format("showBadgeCounts", errors: _errors) ?? "showBadgeCounts";
  @override
  String get defaultFilterDays =>
      _bundle.format("defaultFilterDays", errors: _errors) ??
      "defaultFilterDays";
  @override
  String get invalidDatabaseFile =>
      _bundle.format("invalidDatabaseFile", errors: _errors) ??
      "invalidDatabaseFile";
  @override
  String get databaseImported =>
      _bundle.format("databaseImported", errors: _errors) ?? "databaseImported";
  @override
  String get storageAccessRequired =>
      _bundle.format("storageAccessRequired", errors: _errors) ??
      "storageAccessRequired";
  @override
  String get runningTimersNotificationTitle =>
      _bundle.format("runningTimersNotificationTitle", errors: _errors) ??
      "runningTimersNotificationTitle";
  @override
  String get runningTimersNotificationBody =>
      _bundle.format("runningTimersNotificationBody", errors: _errors) ??
      "runningTimersNotificationBody";
  @override
  String get enableRunningTimersNotification =>
      _bundle.format("enableRunningTimersNotification", errors: _errors) ??
      "enableRunningTimersNotification";
  @override
  String get notes => _bundle.format("notes", errors: _errors) ?? "notes";
  @override
  String get noItemsFound =>
      _bundle.format("noItemsFound", errors: _errors) ?? "noItemsFound";
  @override
  String filterFrom(String dateFrom) =>
      _bundle.format("filterFrom",
          args: <String, dynamic>{"dateFrom": dateFrom}, errors: _errors) ??
      "filterFrom";
  @override
  String filterUntil(String dateUntil) =>
      _bundle.format("filterUntil",
          args: <String, dynamic>{"dateUntil": dateUntil}, errors: _errors) ??
      "filterUntil";
  @override
  String filterFromUntil(String dateFrom, String dateUntil) =>
      _bundle.format("filterFromUntil",
          args: <String, dynamic>{"dateFrom": dateFrom, "dateUntil": dateUntil},
          errors: _errors) ??
      "filterFromUntil";

  @override
  String get notificationPermissionDialogBody =>
      _bundle.format("notificationPermissionDialogBody", errors: _errors) ??
      "notificationPermissionDialogBody";

  @override
  String get notificationPermissionRequired =>
      _bundle.format("notificationPermissionRequired", errors: _errors) ??
      "notificationPermissionRequired";

  @override
  String get thisWeek =>
      _bundle.format("thisWeek", errors: _errors) ?? "thisWeek";
  @override
  String get thisMonth =>
      _bundle.format("thisMonth", errors: _errors) ?? "thisMonth";
  @override
  String get lastMonth =>
      _bundle.format("lastMonth", errors: _errors) ?? "lastMonth";
  @override
  String lastXDays(int days) =>
      _bundle.format("lastXDays",
          args: <String, dynamic>{"days": days}, errors: _errors) ??
      "lastXDays";
  @override
  String plusXDays(int days) =>
      _bundle.format("plusXDays",
          args: <String, dynamic>{"days": days}, errors: _errors) ??
      "plusXDays";
  @override
  String get exportPDF =>
      _bundle.format("exportPDF", errors: _errors) ?? "exportPDF";
  @override
  String get summaryReport =>
      _bundle.format("summaryReport", errors: _errors) ?? "summaryReport";
  @override
  String get dateRange =>
      _bundle.format("dateRange", errors: _errors) ?? "dateRange";
  @override
  String get totalHours =>
      _bundle.format("totalHours", errors: _errors) ?? "totalHours";
  @override
  String get timetable =>
      _bundle.format("timetable", errors: _errors) ?? "timetable";
}
