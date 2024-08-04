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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timecop/screens/dashboard/components/DescriptionField.dart';
import 'package:timecop/screens/dashboard/components/ProjectSelectField.dart';
import 'package:timecop/screens/dashboard/components/RunningTimers.dart';
import 'package:timecop/screens/dashboard/components/StartTimerButton.dart';
import 'package:timecop/screens/dashboard/components/StoppedTimers.dart';
import 'package:timecop/screens/dashboard/components/TopBar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final screenBorders = MediaQuery.of(context).padding;

    return BlocProvider<DashboardBloc>(
        create: (_) => DashboardBloc(projectsBloc, settingsBloc),
        child: Scaffold(
          appBar: const TopBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Expanded(
                flex: 1,
                child: StoppedTimers(),
              ),
              const RunningTimers(),
              Material(
                elevation: 8.0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8 + screenBorders.left, 8,
                      8 + screenBorders.right, 8 + screenBorders.bottom),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ProjectSelectField(),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                          child: DescriptionField(),
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        height: 72,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: const StartTimerButton(),
        ));
  }
}
