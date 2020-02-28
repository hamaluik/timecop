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
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';

class DescriptionField extends StatefulWidget {
  DescriptionField({Key key}) : super(key: key);

  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  TextEditingController _controller;
  FocusNode _focus;

  @override
  void initState() {
    super.initState();
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    assert(bloc != null);
    _controller = TextEditingController(text: bloc.state.newDescription);
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        if(state.timerWasStarted) {
          _controller.clear();
          _focus.unfocus();
          bloc.add(ResetEvent());
        }

        return Container(
          child: TextField(
            focusNode: _focus,
            controller: _controller,
              autocorrect: true,
              decoration: InputDecoration(
                hintText: L10N.of(context).tr.whatAreYouDoing,
              ),
              onChanged: (String description) => bloc.add(DescriptionChangedEvent(description)),
              onSubmitted: (String description) {
                _focus.unfocus();
                bloc.add(DescriptionChangedEvent(description));
              },
            ),
        );
      }
    );
  }
}