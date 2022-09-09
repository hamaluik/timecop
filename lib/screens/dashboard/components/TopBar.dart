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
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timecop/screens/dashboard/components/FilterButton.dart';
import 'package:timecop/screens/dashboard/components/PopupMenu.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  TopBar({Key? key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  final _searchFormKey = GlobalKey<FormState>();
  TextEditingController? _searchController;
  late bool _searching;

  FocusNode? _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searching = false;
    _searchFocusNode = FocusNode(debugLabel: "search-focus");
    _searchController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _searchFocusNode!.dispose();
    _searchController!.dispose();
    super.dispose();
  }

  void cancelSearch() {
    setState(() => _searching = false);
    DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    bloc.add(SearchChangedEvent(null));
  }

  Widget searchBar(BuildContext context) {
    DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);

    return Form(
        key: _searchFormKey,
        child: TextFormField(
          focusNode: _searchFocusNode,
          controller: _searchController,
          style: Theme.of(context).primaryTextTheme.bodyText1,
          onChanged: (search) {
            bloc.add(SearchChangedEvent(search));
          },
          decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                  color: Theme.of(context).colorScheme.onPrimary),
              suffixIcon: IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(FontAwesomeIcons.circleXmark),
                onPressed: cancelSearch,
                tooltip: L10N.of(context).tr.cancel,
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);

    return AppBar(
        leading: _searching
            ? IconButton(
                icon: Icon(FontAwesomeIcons.chevronLeft),
                onPressed: cancelSearch,
                tooltip: L10N.of(context).tr.cancel,
              )
            : PopupMenu(),
        title:
            _searching ? searchBar(context) : Text(L10N.of(context).tr.appName),
        actions: !_searching
            ? <Widget>[
                IconButton(
                  tooltip: L10N.of(context).tr.search,
                  icon: Icon(FontAwesomeIcons.magnifyingGlass),
                  onPressed: () {
                    _searchController!.text = "";
                    bloc.add(SearchChangedEvent(""));
                    setState(() => _searching = true);
                    _searchFocusNode!.requestFocus();
                  },
                ),
                FilterButton(),
              ]
            : <Widget>[]);
  }
}
