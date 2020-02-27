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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timecop/screens/dashboard/components/ProjectSelectField.dart';
import 'package:timecop/screens/dashboard/components/StartTimerButton.dart';

import 'components/DescriptionField.dart';
import 'components/PopupMenu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(FontAwesomeIcons.hourglassHalf),
        title: Text("Time Cop"),
        actions: <Widget>[
          PopupMenu(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[],
            )
          ),
          BlocProvider<DashboardBloc>(
            create: (_) => DashboardBloc(),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: DescriptionField(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                      child: ProjectSelectField(),
                    ),
                    StartTimerButton(),
                  ],
                ),
              ),
            )
          )
        ],
      )
    );
  }
}