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
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class DescriptionField extends StatefulWidget {
  DescriptionField({Key key}) : super(key: key);

  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: BlocProvider.of<DashboardBloc>(context)?.state?.newDescription);
  }

  void _updateDescription(DashboardBloc bloc, String description) {
    bloc.add(DescriptionChangedEvent(description));
  }

  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    assert(bloc != null);

    return Container(
      child: TextField(
        controller: _controller,
          autocorrect: true,
          style: TextStyle(color: Theme.of(context).primaryTextTheme.body1.color),
          decoration: InputDecoration(
            hintText: "What are you doing?",
            hintStyle: TextStyle(color: Theme.of(context).primaryTextTheme.caption.color),
          ),
          onChanged: (String description) => _updateDescription(bloc, description),
        ),
    );
  }
}