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

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timecop/blocs/locale/locale_bloc.dart';
import 'package:timecop/blocs/notifications/notifications_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/settings/settings_state.dart';
import 'package:timecop/blocs/theme/theme_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/data_providers/notifications/notifications_provider.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/fontlicenses.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/DashboardScreen.dart';
import 'package:timecop/themes.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:timecop/data_providers/data/database_provider.dart';
import 'package:timecop/data_providers/settings/shared_prefs_settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SharedPrefsSettingsProvider.load();

  // get a path to the database file
  if (Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final databaseFile = await DatabaseProvider.getDatabaseFile();
  await databaseFile.parent.create(recursive: true);

  final DataProvider data = await DatabaseProvider.open(databaseFile.path);
  final NotificationsProvider notifications =
      await NotificationsProvider.load();
  await runMain(settings, data, notifications);
}

/*import 'package:timecop/data_providers/data/mock_data_provider.dart';
import 'package:timecop/data_providers/settings/mock_settings_provider.dart';
Future<void> main() async {
  final SettingsProvider settings = MockSettingsProvider();
  final DataProvider data = MockDataProvider(Locale.fromSubtags(languageCode: "en"));
  await runMain(settings, data);
}*/

Future<void> runMain(SettingsProvider settings, DataProvider data,
    NotificationsProvider notifications) async {
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
        create: (_) => SettingsBloc(settings, data),
      ),
      BlocProvider<TimersBloc>(
        create: (_) => TimersBloc(data, settings),
      ),
      BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(data),
      ),
      BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(notifications),
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

    SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    TimersBloc timersBloc = BlocProvider.of<TimersBloc>(context);
    settingsBloc.listen((settingsState) => _updateNotificationBadge(
        settingsState, timersBloc.state.countRunningTimers()));
    timersBloc.listen((timersState) => _updateNotificationBadge(
        settingsBloc.state, timersState.countRunningTimers()));

    // send commands to our top-level blocs to get them to initialize
    settingsBloc.add(LoadSettingsFromRepository());
    timersBloc.add(LoadTimers());
    BlocProvider.of<ProjectsBloc>(context).add(LoadProjects());
    BlocProvider.of<ThemeBloc>(context).add(LoadThemeEvent());
    BlocProvider.of<LocaleBloc>(context).add(LoadLocaleEvent());
  }

  void _updateNotificationBadge(SettingsState settingsState, int count) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!settingsState.hasAskedNotificationPermissions &&
          !settingsState.showBadgeCounts) {
        // they haven't set the permission yet
        return;
      } else if (settingsState.showBadgeCounts) {
        // need to ask permission
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      } else {
        // remove any and all badges if we disable the option
        FlutterAppBadger.removeBadge();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("application lifecycle changed to: " + state.toString());
    if (state == AppLifecycleState.paused) {
      SettingsState settings = BlocProvider.of<SettingsBloc>(context).state;
      TimersState timers = BlocProvider.of<TimersBloc>(context).state;

      // TODO: fix this ugly hack. The L10N we load is part of the material app
      // that we build in build(); so we don't have access to it here
      LocaleState localeState = BlocProvider.of<LocaleBloc>(context).state;
      Locale locale = localeState.locale ?? Locale("en");
      L10N l10n = await L10N.load(locale);

      if (settings.showRunningTimersAsNotifications &&
          timers.countRunningTimers() > 0) {
        print("showing notification");
        BlocProvider.of<NotificationsBloc>(context).add(ShowNotification(
            title: l10n.tr.runningTimersNotificationTitle,
            body: l10n.tr.runningTimersNotificationBody));
      } else {
        print("not showing notification");
      }
    } else if (state == AppLifecycleState.resumed) {
      BlocProvider.of<NotificationsBloc>(context).add(RemoveNotifications());
    }
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
                      const Locale('cs'),
                      const Locale('nb', 'NO'),
                    ],
                  ),
                )));
  }
}
