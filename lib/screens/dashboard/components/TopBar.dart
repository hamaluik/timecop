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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/components/FilterButton.dart';
import 'package:timecop/screens/dashboard/components/PopupMenu.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  TopBar({Key key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  final _searchFormKey = GlobalKey<FormState>();
  bool _searching;

  FocusNode _searchFocusNode;

  @override
  void initState() { 
    super.initState();
    _searching = false;
    _searchFocusNode = FocusNode(debugLabel: "search-focus");
  }

  Widget searchBar(BuildContext context) {
    return Form(
      key: _searchFormKey,
      child: TextFormField(
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () => setState(() => _searching = false),
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _searching ? Icon(FontAwesomeIcons.search) : PopupMenu(),
      title: _searching ? searchBar(context) : Text(L10N.of(context).tr.appName),
      actions:
        !_searching
          ? <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.search),
              onPressed: () {
                setState(() => _searching = true);
              },
            ),
            FilterButton(),
          ]
          : <Widget>[]
    );
  }
}