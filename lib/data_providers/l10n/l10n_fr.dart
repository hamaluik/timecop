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

class L10nFr extends L10NProvider {
  @override String get about => "Sur";
  @override String get appDescription => "Une application de suivi du temps qui respecte votre vie privée et fait le travail sans trop de fantaisie.";
  @override String get appLegalese => "Copyright © Kenton Hamaluik, 2020";
  @override String get appName => "Time Cop";
  @override String get areYouSureYouWantToDeletePostfix => "”?";
  @override String get areYouSureYouWantToDeletePrefix => "Etes-vous sûr que vous voulez supprimer “";
  @override String get cancel => "Annuler";
  @override String get changeLog => "Journal des modifications";
  @override String get confirmDelete => "Confirmation de la suppression";
  @override String get create => "Créer";
  @override String get createNewProject => "Créer un nouveau projet";
  @override String get delete => "Supprimer";
  @override String get deleteTimerConfirm => "Voulez-vous vraiment supprimer cette minuterie?";
  @override String get description => "La description";
  @override String get duration => "Durée";
  @override String get editProject => "Modifier le projet";
  @override String get editTimer => "Modifier la minuterie";
  @override String get endTime => "Heure de fin";
  @override String get export => "Exportation";
  @override String get filter => "Filtre";
  @override String get from => "De";
  @override String get includeProjects => "Inclure des projets";
  @override String get logoSemantics => "Logo de Time Cop";
  @override String get noProject => "(pas de projet)";
  @override String get pleaseEnterAName => "Veuillez saisir un nom";
  @override String get project => "Projet";
  @override String get projectName => "nom du projet";
  @override String get projects => "Projets";
  @override String get readme => "Lisezmoi";
  @override String get runningTimers => "Minuteurs de course";
  @override String get save => "sauvegarder";
  @override String get sourceCode => "Code source";
  @override String get startTime => "Heure de début";
  @override String get timeH => "Temps (heures)";
  @override String get to => "À";
  @override String get whatAreYouDoing => "Que faites-vous?";
  @override String get whatWereYouDoing => "Que faisiez-vous?";
}