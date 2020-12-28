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

import 'package:flutter/material.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';
import 'dart:math';

class MockDataProvider extends DataProvider {
  String localeKey;
  static final Map<String, Map<String, String>> l10n = {
    "ar": {
      "ui-layout": "تخطيط واجهة المستخدم",
      "administration": "الادارة",
      "coffee": "قهوة",
      "mockups": "نموذج تجريبي",
      "app-development": "تطوير التطبيق",
    },
    "de": {
      "app-development": "App-Entwicklung",
      "administration": "Verwaltung",
      "coffee": "Kaffee",
      "ui-layout": "UI-Layout",
      "mockups": "Modelle",
    },
    "en": {
      "administration": "Administration",
      "mockups": "Mockups",
      "ui-layout": "UI Layout",
      "coffee": "Coffee",
      "app-development": "App development"
    },
    "es": {
      "administration": "Administración",
      "ui-layout": "Diseño de interfaz de usuario",
      "app-development": "Desarrollo de aplicaciones",
      "coffee": "café",
      "mockups": "Maquetas",
    },
    "fr": {
      "ui-layout": "Disposition de l'interface utilisateur",
      "coffee": "café",
      "administration": "Administration",
      "mockups": "Maquettes",
      "app-development": "Développement d'applications",
    },
    "hi": {
      "mockups": "मॉक-अप",
      "coffee": "कॉफ़ी",
      "ui-layout": "यूआई लेआउट",
      "administration": "शासन प्रबंध",
      "app-development": "अनुप्रयोग विकास",
    },
    "id": {
      "app-development": "Pengembangan aplikasi",
      "coffee": "kopi",
      "ui-layout": "Layout UI",
      "mockups": "Maket",
      "administration": "Administrasi",
    },
    "ja": {
      "ui-layout": "UIレイアウト",
      "mockups": "モックアップ",
      "app-development": "アプリ開発",
      "administration": "行政",
      "coffee": "コーヒー",
    },
    "ko": {
      "app-development": "앱 개발",
      "coffee": "커피",
      "mockups": "모형",
      "ui-layout": "UI 레이아웃",
      "administration": "관리",
    },
    "pt": {
      "coffee": "Café",
      "mockups": "Maquetes",
      "ui-layout": "Layout da interface do usuário",
      "app-development": "Desenvolvimento de aplicativos",
      "administration": "Administração",
    },
    "ru": {
      "mockups": "Макеты",
      "coffee": "Кофе",
      "app-development": "Разработка приложений",
      "ui-layout": "Макет пользовательского интерфейса",
      "administration": "администрация",
    },
    "zh-CN": {
      "ui-layout": "UI布局",
      "administration": "管理",
      "coffee": "咖啡",
      "mockups": "样机",
      "app-development": "应用程式开发",
    },
    "zh-TW": {
      "administration": "管理",
      "mockups": "樣機",
      "app-development": "應用程式開發",
      "coffee": "咖啡",
      "ui-layout": "UI佈局",
    },
    "it": {
      "app-development": "Sviluppo di app",
      "coffee": "caffè",
      "ui-layout": "Layout dell'interfaccia utente",
      "administration": "Amministrazione",
      "mockups": "Mockups",
    }
  };

  MockDataProvider(Locale locale) {
    localeKey = locale.languageCode;
    if (locale.languageCode == "zh") {
      localeKey += "-" + locale.countryCode;
    }
  }

  @override
  Future<List<Project>> listProjects() async {
    return <Project>[
      Project(
          id: 1, name: "Time Cop", colour: Colors.cyan[600], archived: false),
      Project(
        id: 2,
        name: l10n[localeKey]["administration"],
        colour: Colors.pink[600],
        archived: false,
      ),
    ];
  }

  @override
  Future<List<TimerEntry>> listTimers() async {
    int tid = 1;
    Random rand = Random(42);

    // start with running timers
    List<TimerEntry> entries = [
      TimerEntry(
        id: tid++,
        description: l10n[localeKey]["ui-layout"],
        projectID: 1,
        startTime: DateTime.now()
            .subtract(Duration(hours: 2, minutes: 10, seconds: 1)),
        endTime: null,
      ),
      TimerEntry(
        id: tid++,
        description: l10n[localeKey]["coffee"],
        projectID: 2,
        startTime: DateTime.now().subtract(Duration(minutes: 3, seconds: 14)),
        endTime: null,
      ),
    ];

    // add some fake March stuff
    for (int w = 0; w < 4; w++) {
      for (int d = 0; d < 5; d++) {
        String descriptionKey;
        double r = rand.nextDouble();
        if (r <= 0.2) {
          descriptionKey = 'mockups';
        } else if (r <= 0.5) {
          descriptionKey = 'ui-layout';
        } else {
          descriptionKey = 'app-development';
        }

        entries.add(TimerEntry(
          id: tid++,
          description: l10n[localeKey][descriptionKey],
          projectID: 1,
          startTime: DateTime(
            2020,
            3,
            (w * 7) + d + 2,
            rand.nextInt(3) + 8,
            rand.nextInt(60),
            rand.nextInt(60),
          ),
          endTime: DateTime(
            2020,
            3,
            (w * 7) + d + 2,
            rand.nextInt(3) + 13,
            rand.nextInt(60),
            rand.nextInt(60),
          ),
        ));

        entries.add(TimerEntry(
          id: tid++,
          description: l10n[localeKey]['administration'],
          projectID: 2,
          startTime: DateTime(
            2020,
            3,
            (w * 7) + d + 2,
            14,
            rand.nextInt(30),
            rand.nextInt(60),
          ),
          endTime: DateTime(
            2020,
            3,
            (w * 7) + d + 2,
            15,
            rand.nextInt(30),
            rand.nextInt(60),
          ),
        ));
      }
    }
    return entries;
  }

  @override
  Future<Project> createProject(
      {@required String name, Color colour, bool archived}) async {
    return Project(
        id: -1, name: name, colour: colour, archived: archived ?? false);
  }

  @override
  Future<void> editProject(Project project) async {}
  @override
  Future<void> deleteProject(Project project) async {}
  @override
  Future<TimerEntry> createTimer(
      {String description,
      int projectID,
      DateTime startTime,
      DateTime endTime}) async {
    DateTime st = startTime ?? DateTime.now();
    return TimerEntry(
      id: -1,
      description: description,
      projectID: projectID,
      startTime: st,
      endTime: endTime,
    );
  }

  @override
  Future<void> editTimer(TimerEntry timer) async {}
  @override
  Future<void> deleteTimer(TimerEntry timer) async {}
}
