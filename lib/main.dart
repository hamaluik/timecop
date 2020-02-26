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

import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/blocs/settings/settings_event.dart';
import 'package:timecop/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'blocs/theme/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsRepository settings = await SettingsRepository.load();

  assert(settings != null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(settings),
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
  final SettingsRepository settings;
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
    BlocProvider.of<SettingsBloc>(context).add(LoadSettingsFromRepository());
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
        RepositoryProvider<SettingsRepository>.value(value: widget.settings),
      ],
      child: MaterialApp(
        title: 'TimeCop',
        theme: BlocProvider.of<ThemeBloc>(context).state.theme,
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: body,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentScreen.index,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.stream), title: Text("Logs"), backgroundColor: BlocProvider.of<ThemeBloc>(context).state.theme.accentColor),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.projectDiagram), title: Text("Projects"), backgroundColor: BlocProvider.of<ThemeBloc>(context).state.theme.accentColor),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.fileExport), title: Text("Export"), backgroundColor: BlocProvider.of<ThemeBloc>(context).state.theme.accentColor),
              BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.cogs), title: Text("Settings"), backgroundColor: BlocProvider.of<ThemeBloc>(context).state.theme.accentColor),
            ],
            onTap: (index) => setState(() {
              _currentScreen = Screen.values[index];
            })
          ),
        ),
      )
    );
  }
}
