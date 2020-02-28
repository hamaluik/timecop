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

import 'package:timecop/data_providers/l10n_provider.dart';

class L10nEn extends L10NProvider {
  @override String get about => "About";
  @override String get appDescription => "A time tracking app that respects your privacy and gets the job done without getting too fancy.";
  @override String get appLegalese => "Copyright © Kenton Hamaluik, 2020";
  @override String get appName => "Time Cop";
  @override String get areYouSureYouWantToDeletePostfix => "”?";
  @override String get areYouSureYouWantToDeletePrefix => "Are you sure you want to delete “";
  @override String get cancel => "Cancel";
  @override String get changeLog => "Change Log";
  @override String get confirmDelete => "Confirm Delete";
  @override String get create => "Create";
  @override String get createNewProject => "Create New Project";
  @override String get delete => "Delete";
  @override String get deleteTimerConfirm => "Are you sure you want to delete this timer?";
  @override String get description => "Description";
  @override String get duration => "Duration";
  @override String get editProject => "Edit Project";
  @override String get editTimer => "Edit Timer";
  @override String get endTime => "End Time";
  @override String get export => "Export";
  @override String get filter => "Filter";
  @override String get from => "From";
  @override String get includeProjects => "Include Projects";
  @override String get logoSemantics => "Time Cop Logo";
  @override String get noProject => "(no project)";
  @override String get pleaseEnterAName => "Please enter a name";
  @override String get project => "Project";
  @override String get projectName => "Project Name";
  @override String get projects => "Projects";
  @override String get readme => "Readme";
  @override String get runningTimers => "Running Timers";
  @override String get save => "Save";
  @override String get sourceCode => "Source Code";
  @override String get startTime => "Start Time";
  @override String get timeH => "Time (hours)";
  @override String get to => "To";
  @override String get whatAreYouDoing => "What are you doing?";
  @override String get whatWereYouDoing => "What were you doing?";
}