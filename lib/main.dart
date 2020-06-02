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
import 'package:timecop/blocs/locale/locale_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/theme/theme_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/fontlicenses.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/DashboardScreen.dart';
import 'package:timecop/themes.dart';

import 'package:timecop/data_providers/data/database_provider.dart';
import 'package:timecop/data_providers/settings/shared_prefs_settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SharedPrefsSettingsProvider.load();
  final DataProvider data = await DatabaseProvider.open();
  await runMain(settings, data);
}

/*import 'package:timecop/data_providers/data/mock_data_provider.dart';
import 'package:timecop/data_providers/settings/mock_settings_provider.dart';
Future<void> main() async {
  final SettingsProvider settings = MockSettingsProvider();
  final DataProvider data = MockDataProvider(Locale.fromSubtags(languageCode: "en"));
  await runMain(settings, data);
}*/

Future<void> runMain(SettingsProvider settings, DataProvider data) async {
  // setup intl date formats?
  //await initializeDateFormatting();
  LicenseRegistry.addLicense(getFontLicenses);

  assert(settings != null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(settings),
      ),
      BlocProvider<LocaleBloc>(
        create: (_) => LocaleBloc(settings),
      ),
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

class _TimeCopAppState extends State<TimeCopApp> with WidgetsBindingObserver {
  Timer _updateTimersTimer;
  Brightness brightness;

  @override
  void initState() {
    _updateTimersTimer = Timer.periodic(Duration(seconds: 1),
        (_) => BlocProvider.of<TimersBloc>(context).add(UpdateNow()));
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.window.platformBrightness;

    // send commands to our top-level blocs to get them to initialize
    BlocProvider.of<SettingsBloc>(context).add(LoadSettingsFromRepository());
    BlocProvider.of<TimersBloc>(context).add(LoadTimers());
    BlocProvider.of<ProjectsBloc>(context).add(LoadProjects());
    BlocProvider.of<ThemeBloc>(context).add(LoadThemeEvent());
    BlocProvider.of<LocaleBloc>(context).add(LoadLocaleEvent());
  }

  @override
  void dispose() {
    _updateTimersTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    print(WidgetsBinding.instance.window.platformBrightness.toString());
    setState(
        () => brightness = WidgetsBinding.instance.window.platformBrightness);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SettingsProvider>.value(value: widget.settings),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (BuildContext context, ThemeState themeState) =>
                BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (BuildContext context, LocaleState localeState) =>
                      MaterialApp(
                    title: 'Time Cop',
                    home: DashboardScreen(),
                    theme: themeState.themeData ??
                        (brightness == Brightness.dark
                            ? darkTheme
                            : lightTheme),
                    localizationsDelegates: [
                      L10N.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: localeState.locale,
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
                      const Locale('it'),
                    ],
                  ),
                )));
  }
}
