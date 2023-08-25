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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:timecop/screens/dashboard/components/FilterButton.dart';
import 'package:timecop/screens/dashboard/components/PopupMenu.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late bool _searching;

  final _searchFormKey = GlobalKey<FormState>();
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searching = false;
    _searchFocusNode = FocusNode(debugLabel: "search-focus");
    _searchController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void cancelSearch() {
    setState(() => _searching = false);
    final bloc = BlocProvider.of<DashboardBloc>(context);
    bloc.add(const SearchChangedEvent(null));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    return AppBar(
        leading: _searching
            ? IconButton(
                icon: const Icon(FontAwesomeIcons.chevronLeft),
                onPressed: cancelSearch,
                tooltip: L10N.of(context).tr.cancel,
              )
            : const PopupMenu(),
        title: _searching
            ? _SearchBar(
                cancelSearch: cancelSearch,
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                searchFormKey: _searchFormKey,
              )
            : Row(mainAxisSize: MainAxisSize.min, children: [
                SvgPicture.asset(
                  "icon.no-bg.svg",
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).appBarTheme.foregroundColor ??
                          Colors.white,
                      BlendMode.srcIn),
                  height: 28,
                  semanticsLabel: L10N.of(context).tr.logoSemantics,
                ),
                const SizedBox(width: 8),
                Text(L10N.of(context).tr.appName)
              ]),
        actions: !_searching
            ? <Widget>[
                IconButton(
                  tooltip: L10N.of(context).tr.search,
                  icon: const Icon(FontAwesomeIcons.magnifyingGlass),
                  onPressed: () {
                    _searchController.text = "";
                    bloc.add(const SearchChangedEvent(""));
                    setState(() => _searching = true);
                    _searchFocusNode.requestFocus();
                  },
                ),
                const FilterButton(),
              ]
            : <Widget>[]);
  }
}

class _SearchBar extends StatelessWidget {
  final Function() cancelSearch;
  final GlobalKey<FormState> searchFormKey;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  const _SearchBar(
      {required this.cancelSearch,
      required this.searchFormKey,
      required this.searchController,
      required this.searchFocusNode});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    return Form(
        key: searchFormKey,
        child: TextFormField(
          focusNode: searchFocusNode,
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          style: Theme.of(context)
              .primaryTextTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor),
          onChanged: (search) {
            bloc.add(SearchChangedEvent(search));
          },
          decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                  color: Theme.of(context).appBarTheme.foregroundColor),
              suffixIcon: IconButton(
                color: Theme.of(context).appBarTheme.foregroundColor,
                icon: const Icon(FontAwesomeIcons.circleXmark),
                onPressed: cancelSearch,
                tooltip: L10N.of(context).tr.cancel,
              )),
        ));
  }
}
