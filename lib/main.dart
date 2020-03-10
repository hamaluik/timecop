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
import 'package:timecop/data_providers/shared_prefs_settings_provider.dart';
import 'package:timecop/fontlicenses.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/DashboardScreen.dart';
import 'package:timecop/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SharedPrefsSettingsProvider.load();
  final DataProvider data = await DatabaseProvider.open();
  await runMain(settings, data);
}

Future<void> runMain(SettingsProvider settings, DataProvider data) async {
  // setup intl date formats?
  //await initializeDateFormatting();
  LicenseRegistry.addLicense(getFontLicenses);

  assert(settings != null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(settings),
      ),
      BlocProvider<TimersBloc>(
        create: (_) => TimersBloc(data),
      ),
      BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(data),
      ),
    ],
    child: TimeCopApp(settings: settings),
  ));
}

class TimeCopApp extends StatefulWidget {
  final SettingsProvider settings;
  const TimeCopApp({Key key, @required this.settings})
      : assert(settings != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeCopAppState();
}

class _TimeCopAppState extends State<TimeCopApp> {
  Timer _updateTimersTimer;

  @override
  void initState() {
    _updateTimersTimer = Timer.periodic(Duration(seconds: 1), (_) => BlocProvider.of<TimersBloc>(context).add(UpdateNow()));
    super.initState();

    // send commands to our top-level blocs to get them to initialize
    BlocProvider.of<SettingsBloc>(context).add(LoadSettingsFromRepository());
    BlocProvider.of<TimersBloc>(context).add(LoadTimers());
    BlocProvider.of<ProjectsBloc>(context).add(LoadProjects());
  }

  @override
  void dispose() {
    _updateTimersTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsProvider>.value(value: widget.settings),
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
      )
    );
  }
}
