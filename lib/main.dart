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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/data_providers/data_provider.dart';
import 'package:timecop/data_providers/database_provider.dart';
import 'package:timecop/data_providers/settings_provider.dart';
import 'package:timecop/fontlicenses.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/DashboardScreen.dart';
import 'package:timecop/themes.dart';

void main() async {
  runApp(TimeCopApp(testMode: false));
}

class TimeCopApp extends StatefulWidget {
  final bool testMode;
  const TimeCopApp({Key key, @required this.testMode})
      : assert(testMode != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeCopAppState();
}

class _TimeCopAppState extends State<TimeCopApp> {
  Timer _updateTimersTimer;
  SettingsProvider _settings;
  DataProvider _data;
  TimersBloc _timers;

  @override
  void initState() {
    SettingsProvider.load().then((SettingsProvider s) {
      setState(() => _settings = s);
    });
    DatabaseProvider.open().then((DatabaseProvider d) async {
      if(widget.testMode) {
        await d.factoryReset();
        await d.insertDemoData();
      }

      setState(() => _data = d);
    });

    LicenseRegistry.addLicense(getFontLicenses);

    _updateTimersTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if(_timers != null) {
        _timers.add(UpdateNow());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _updateTimersTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_settings == null || _data == null) {
      return MaterialApp(
        title: 'Time Cop',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Container(),
        localizationsDelegates: [
          L10N.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('fr'),
          const Locale('de'),
          const Locale('es'),
          const Locale('hi'),
          const Locale('id'),
          const Locale('ja'),
          const Locale('ko'),
          const Locale('pt'),
          const Locale('ru'),
          const Locale('zh', 'CN'),
          const Locale('zh', 'TW'),
          const Locale('ar'),
        ],
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) {
            SettingsBloc bloc = SettingsBloc(_settings);
            if(widget.testMode) {
              bloc.add(FactoryResetSettings());
            }
            else {
              bloc.add(LoadSettingsFromRepository());
            }
            return bloc;
          },
        ),
        BlocProvider<TimersBloc>(
          create: (_) {
            TimersBloc bloc = TimersBloc(_data);
            bloc.add(LoadTimers());
            _timers = bloc;
            return bloc;
          },
        ),
        BlocProvider<ProjectsBloc>(
          create: (_) {
            ProjectsBloc bloc = ProjectsBloc(_data);
            bloc.add(LoadProjects());
            return bloc;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Time Cop',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: DashboardScreen(),
        localizationsDelegates: [
          L10N.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('fr'),
          const Locale('de'),
          const Locale('es'),
          const Locale('hi'),
          const Locale('id'),
          const Locale('ja'),
          const Locale('ko'),
          const Locale('pt'),
          const Locale('ru'),
          const Locale('zh', 'CN'),
          const Locale('zh', 'TW'),
          const Locale('ar'),
        ],
      ),
    );
  }
}
