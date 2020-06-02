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
import 'package:timecop/blocs/theme/theme_bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/theme_type.dart';

class ThemeOptions extends StatelessWidget {
  final ThemeBloc bloc;
  const ThemeOptions({Key key, @required this.bloc})
      : assert(bloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
        bloc: bloc,
        builder: (BuildContext context, ThemeState state) {
          return ListTile(
            key: Key("themeOption"),
            title: Text(L10N.of(context).tr.theme),
            subtitle: Text(state.theme.display(context)),
            trailing: Icon(L10N.of(context).rtl
                ? FontAwesomeIcons.chevronLeft
                : FontAwesomeIcons.chevronRight),
            leading: Icon(FontAwesomeIcons.palette),
            onTap: () async {
              ThemeType oldTheme = state.theme;
              ThemeType newTheme = await showModalBottomSheet<ThemeType>(
                  context: context,
                  builder: (context) => ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          RadioListTile<ThemeType>(
                            key: Key("themeAuto"),
                            title: Text(L10N.of(context).tr.auto),
                            value: ThemeType.auto,
                            groupValue: state.theme,
                            onChanged: (ThemeType type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: Key("themeLight"),
                            title: Text(L10N.of(context).tr.light),
                            value: ThemeType.light,
                            groupValue: state.theme,
                            onChanged: (ThemeType type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: Key("themeDark"),
                            title: Text(L10N.of(context).tr.dark),
                            value: ThemeType.dark,
                            groupValue: state.theme,
                            onChanged: (ThemeType type) =>
                                Navigator.pop(context, type),
                          ),
                          RadioListTile<ThemeType>(
                            key: Key("themeBlack"),
                            title: Text(L10N.of(context).tr.black),
                            value: ThemeType.black,
                            groupValue: state.theme,
                            onChanged: (ThemeType type) =>
                                Navigator.pop(context, type),
                          ),
                        ],
                      ));

              bloc.add(ChangeThemeEvent(newTheme ?? oldTheme));
            },
          );
        });
  }
}
