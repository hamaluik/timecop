import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

class TimeCopLocalizations {
  TimeCopLocalizations(this.localeName);

  static const LocalizationsDelegate<TimeCopLocalizations> delegate = _TimeCopLocalizationsDelegate();

  static Future<TimeCopLocalizations> load(Locale locale) async {
    final String name = (locale.countryCode?.isEmpty ?? true) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    print("loading messages for locale $localeName...");
    return initializeMessages(localeName).then((bool success) {
      print("success: $success");
      return TimeCopLocalizations(localeName);
    });
  }

  static TimeCopLocalizations of(BuildContext context) {
    return Localizations.of<TimeCopLocalizations>(context, TimeCopLocalizations);
  }

  final String localeName;

String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  String get appDescription {
    return Intl.message(
      'A time tracking app that respects your privacy and gets the job done without getting too fancy.',
      name: 'appDescription',
      desc: '',
      args: [],
    );
  }

  String get appLegalese {
    return Intl.message(
      'Copyright © Kenton Hamaluik, 2020',
      name: 'appLegalese',
      desc: '',
      args: [],
    );
  }

  String get readme {
    return Intl.message(
      'Readme',
      name: 'readme',
      desc: '',
      args: [],
    );
  }

  String get changeLog {
    return Intl.message(
      'Change Log',
      name: 'changeLog',
      desc: '',
      args: [],
    );
  }

  String get sourceCode {
    return Intl.message(
      'Source Code',
      name: 'sourceCode',
      desc: '',
      args: [],
    );
  }

  String get whatAreYouDoing {
    return Intl.message(
      'What are you doing?',
      name: 'whatAreYouDoing',
      desc: '',
      args: [],
    );
  }

  String get projects {
    return Intl.message(
      'Projects',
      name: 'projects',
      desc: '',
      args: [],
    );
  }

  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  String get noProject {
    print('getting (no project) string..');
    print('localName: ' + localeName);
    String msg = Intl.message(
      '(no project)',
      name: 'noProject',
      desc: '',
      args: [],
    );
    print('got message: ' + msg);
    return msg;
  }

  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  String get deleteTimerConfirm {
    return Intl.message(
      'Are you sure you want to delete this timer?',
      name: 'deleteTimerConfirm',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  String get runningTimers {
    return Intl.message(
      'Running Timers',
      name: 'runningTimers',
      desc: '',
      args: [],
    );
  }

  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  String get includeProjects {
    return Intl.message(
      'Include Projects',
      name: 'includeProjects',
      desc: '',
      args: [],
    );
  }

  String get project {
    return Intl.message(
      'Project',
      name: 'project',
      desc: '',
      args: [],
    );
  }

  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  String get timeH {
    return Intl.message(
      'Time (hours)',
      name: 'timeH',
      desc: '',
      args: [],
    );
  }

  String get createNewProject {
    return Intl.message(
      'Create New Project',
      name: 'createNewProject',
      desc: '',
      args: [],
    );
  }

  String get editProject {
    return Intl.message(
      'Edit Project',
      name: 'editProject',
      desc: '',
      args: [],
    );
  }

  String get pleaseEnterAName {
    return Intl.message(
      'Please enter a name',
      name: 'pleaseEnterAName',
      desc: '',
      args: [],
    );
  }

  String get projectName {
    return Intl.message(
      'Project Name',
      name: 'projectName',
      desc: '',
      args: [],
    );
  }

  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  String get areYouSureYouWantToDeletePrefix {
    return Intl.message(
      'Are you sure you want to delete “',
      name: 'areYouSureYouWantToDeletePrefix',
      desc: '',
      args: [],
    );
  }

  String get areYouSureYouWantToDeletePostfix {
    return Intl.message(
      '”?',
      name: 'areYouSureYouWantToDeletePostfix',
      desc: '',
      args: [],
    );
  }

  String get editTimer {
    return Intl.message(
      'Edit Timer',
      name: 'editTimer',
      desc: '',
      args: [],
    );
  }

  String get whatWereYouDoing {
    return Intl.message(
      'What were you doing?',
      name: 'whatWereYouDoing',
      desc: '',
      args: [],
    );
  }

  String get startTime {
    return Intl.message(
      'Start Time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  String get endTime {
    return Intl.message(
      'End Time',
      name: 'endTime',
      desc: '',
      args: [],
    );
  }

  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  String get appName {
    return Intl.message(
      'Time Cop',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  String get logoSemantics {
    return Intl.message(
      'Time Cop Logo',
      name: 'logoSemantics',
      desc: '',
      args: [],
    );
  }
}

class _TimeCopLocalizationsDelegate extends LocalizationsDelegate<TimeCopLocalizations> {
  const _TimeCopLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['de', 'en', 'es', 'fr', 'hi', 'id', 'ja', 'ko', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  Future<TimeCopLocalizations> load(Locale locale) => TimeCopLocalizations.load(locale);

  @override
  bool shouldReload(_TimeCopLocalizationsDelegate old) => false;
}