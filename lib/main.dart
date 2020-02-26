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

import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/data_providers/data_provider.dart';
import 'package:timecop/data_providers/database_provider.dart';
import 'package:timecop/data_providers/settings_provider.dart';
import 'package:timecop/screens/dashboard/DashboardScreen.dart';
import 'blocs/theme/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SettingsProvider.load();
  final DataProvider data = await DatabaseProvider.open();

  assert(settings != null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
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
    child: BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) =>
          _TimeCopApp(settings: settings),
    ),
  ));
}

/// TimeCop app is stateful so it can listen to platform brightness changes
/// using `WidgetsBindingObserver`
class _TimeCopApp extends StatefulWidget {
  final SettingsProvider settings;
  const _TimeCopApp({Key key, @required this.settings})
      : assert(settings != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeCopAppState();
}

enum Screen { logs, projects, export, settings }

class _TimeCopAppState extends State<_TimeCopApp>
    with WidgetsBindingObserver {
  Screen _currentScreen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentScreen = Screen.logs;

    // send commands to our top-level blocs to get them to initialize
    BlocProvider.of<SettingsBloc>(context).add(LoadSettingsFromRepository());
    BlocProvider.of<TimersBloc>(context).add(LoadTimers());
    BlocProvider.of<ProjectsBloc>(context).add(LoadProjects());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    BlocProvider.of<ThemeBloc>(context)
        .add(BrightnessChanged(brightness: brightness));
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch(_currentScreen) {
      case Screen.logs:
        body = Container();
        break;
      case Screen.projects:
        body = Container();
        break;
      case Screen.export:
        body = Container();
        break;
      case Screen.settings:
        body = Container();
        break;
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsProvider>.value(value: widget.settings),
      ],
      child: MaterialApp(
        title: 'TimeCop',
        theme: BlocProvider.of<ThemeBloc>(context).state.theme,
        home: DashboardScreen(),
      )
    );
  }
}
