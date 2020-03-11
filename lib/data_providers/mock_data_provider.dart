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
import 'package:timecop/data_providers/data_provider.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/models/timer_entry.dart';

class MockDataProvider extends DataProvider {
  String localeKey;
  static final Map<String, Map<String, String>> l10n = {
    "ar": {
      "mockups": "نموذج تجريبي",
      "wireframing": "الإطار السلكي",
      "client-meeting": "اجتماع العملاء",
      "administration": "الادارة",
      "ui-layout": "تخطيط واجهة المستخدم",
      "coffee": "قهوة",
    },
    "de": {
      "client-meeting": "Kundenbesprechung",
      "administration": "Verwaltung",
      "mockups": "Modelle",
      "ui-layout": "UI-Layout",
      "coffee": "Kaffee",
      "wireframing": "Wireframing",
    },
    "en": {
      "administration": "Administration",
      "wireframing": "Wireframing",
      "mockups": "Mockups",
      "client-meeting": "Client meeting",
      "ui-layout": "UI Layout",
      "coffee": "Coffee",
    },
    "es": {
      "mockups": "Maquetas",
      "administration": "Administración",
      "wireframing": "Wireframing",
      "client-meeting": "Reunión del cliente",
      "ui-layout": "Diseño de interfaz de usuario",
      "coffee": "café",
    },
    "fr": {
      "coffee": "café",
      "ui-layout": "Disposition de l'interface utilisateur",
      "client-meeting": "Réunion client",
      "mockups": "Maquettes",
      "administration": "Administration",
      "wireframing": "Wireframing",
    },
    "hi": {
      "coffee": "कॉफ़ी",
      "wireframing": "wireframing",
      "mockups": "मॉक-अप",
      "ui-layout": "यूआई लेआउट",
      "administration": "शासन प्रबंध",
      "client-meeting": "ग्राहक बैठक",
    },
    "id": {
      "ui-layout": "Layout UI",
      "wireframing": "Wireframing",
      "mockups": "Maket",
      "client-meeting": "Pertemuan klien",
      "coffee": "kopi",
      "administration": "Administrasi",
    },
    "ja": {
      "client-meeting": "クライアントミーティング",
      "wireframing": "ワイヤーフレーム",
      "coffee": "コーヒー",
      "ui-layout": "UIレイアウト",
      "administration": "運営管理",
      "mockups": "モックアップ",
    },
    "ko": {
      "coffee": "커피",
      "wireframing": "와이어 프레임",
      "administration": "관리",
      "client-meeting": "고객 회의",
      "ui-layout": "UI 레이아웃",
      "mockups": "모형",
    },
    "pt": {
      "client-meeting": "Reunião do cliente",
      "mockups": "Maquetes",
      "coffee": "Café",
      "ui-layout": "Layout da interface do usuário",
      "wireframing": "Wireframing",
      "administration": "Administração",
    },
    "ru": {
      "wireframing": "Wireframing",
      "mockups": "Макеты",
      "client-meeting": "Встреча с клиентом",
      "ui-layout": "Макет пользовательского интерфейса",
      "administration": "администрация",
      "coffee": "Кофе",
    },
    "zh-CN": {
      "administration": "管理",
      "ui-layout": "UI布局",
      "mockups": "样机",
      "wireframing": "线框",
      "client-meeting": "客户会议",
      "coffee": "咖啡",
    },
    "zh-TW": {
      "wireframing": "線框",
      "ui-layout": "UI佈局",
      "client-meeting": "客戶會議",
      "mockups": "樣機",
      "coffee": "咖啡",
      "administration": "管理",
    },
  };

  MockDataProvider(Locale locale) {
    localeKey = locale.languageCode;
    if(locale.languageCode == "zh") {
      localeKey += "-" + locale.countryCode;
    }
  }

  Future<List<Project>> listProjects() async {
    return <Project>[
      Project(id: 1, name: "Time Cop", colour: Colors.cyan[600]),
      Project(id: 2, name: l10n[localeKey]["administration"], colour: Colors.pink[600]),
    ];
  }
  Future<List<TimerEntry>> listTimers() async {
    return <TimerEntry>[
      TimerEntry(
        id: 1,
        description: l10n[localeKey]["wireframing"],
        projectID: 1,
        startTime: DateTime.now().subtract(Duration(days: 2, hours: 9, minutes: 22, seconds: 9)),
        endTime: DateTime.now().subtract(Duration(days: 2)),
      ),
      TimerEntry(
        id: 2,
        description: l10n[localeKey]["mockups"],
        projectID: 1,
        startTime: DateTime.now().subtract(Duration(days: 1, hours: 7, minutes: 9, seconds: 31)),
        endTime: DateTime.now().subtract(Duration(days: 1))
      ),
      TimerEntry(
        id: 3,
        description: l10n[localeKey]["client-meeting"],
        projectID: 2,
        startTime: DateTime.now().subtract(Duration(days: 1, hours: 0, minutes: 42, seconds: 17)),
        endTime: DateTime.now().subtract(Duration(days: 1))
      ),
      TimerEntry(
        id: 1,
        description: l10n[localeKey]["ui-layout"],
        projectID: 1,
        startTime: DateTime.now().subtract(Duration(hours: 2, minutes: 10, seconds: 1)),
        endTime: null,
      ),
      TimerEntry(
        id: 1,
        description: l10n[localeKey]["coffee"],
        projectID: 2,
        startTime: DateTime.now().subtract(Duration(minutes: 3, seconds: 14)),
        endTime: null,
      ),
    ];
  }

  Future<Project> createProject({@required String name, Color colour}) async {
    return Project(id: -1, name: name, colour: colour);
  }
  Future<void> editProject(Project project) async {}
  Future<void> deleteProject(Project project) async {}
  Future<TimerEntry> createTimer({String description, int projectID, DateTime startTime, DateTime endTime}) async {
    return TimerEntry(
      id: -1,
      description: description,
      projectID: projectID,
      startTime: startTime,
      endTime: endTime,
    );
  }
  Future<void> editTimer(TimerEntry timer) async {}
  Future<void> deleteTimer(TimerEntry timer) async {}
}