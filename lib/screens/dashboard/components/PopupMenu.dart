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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/about/AboutScreen.dart';
import 'package:timecop/screens/export/ExportScreen.dart';
import 'package:timecop/screens/projects/ProjectsScreen.dart';
import 'package:timecop/screens/reports/ReportsScreen.dart';
import 'package:timecop/screens/settings/SettingsScreen.dart';

enum MenuItem {
  projects,
  reports,
  export,
  settings,
  about,
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      key: Key("menuButton"),
      icon: SvgPicture.asset(
        "icon.no-bg.svg",
        height: 30,
        semanticsLabel: L10N.of(context).tr.logoSemantics,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      onSelected: (MenuItem item) {
        switch (item) {
          case MenuItem.projects:
            Navigator.of(context).push(MaterialPageRoute<ProjectsScreen>(
              builder: (BuildContext _context) => ProjectsScreen(),
            ));
            break;
          case MenuItem.reports:
            Navigator.of(context).push(MaterialPageRoute<ReportsScreen>(
              builder: (BuildContext _context) => ReportsScreen(),
            ));
            break;
          case MenuItem.export:
            Navigator.of(context).push(MaterialPageRoute<ExportScreen>(
              builder: (BuildContext _context) => ExportScreen(),
            ));
            break;
          case MenuItem.settings:
            Navigator.of(context).push(MaterialPageRoute<SettingsScreen>(
              builder: (BuildContext _context) => SettingsScreen(),
            ));
            break;
          case MenuItem.about:
            Navigator.of(context).push(MaterialPageRoute<AboutScreen>(
              builder: (BuildContext _context) => AboutScreen(),
            ));
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            key: Key("menuProjects"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.layerGroup),
              title: Text(L10N.of(context).tr.projects),
            ),
            value: MenuItem.projects,
          ),
          PopupMenuItem(
            key: Key("menuReports"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.chartPie),
              title: Text(L10N.of(context).tr.reports),
            ),
            value: MenuItem.reports,
          ),
          PopupMenuItem(
            key: Key("menuExport"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.fileExport),
              title: Text(L10N.of(context).tr.export),
            ),
            value: MenuItem.export,
          ),
          PopupMenuItem(
            key: Key("menuSettings"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.screwdriver),
              title: Text(L10N.of(context).tr.settings),
            ),
            value: MenuItem.settings,
          ),
          PopupMenuItem(
            key: Key("menuAbout"),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.dna),
              title: Text(L10N.of(context).tr.about),
            ),
            value: MenuItem.about,
          ),
        ];
      },
    );
  }
}
