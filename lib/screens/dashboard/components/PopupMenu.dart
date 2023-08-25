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
  const PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      key: const Key("menuButton"),
      icon: const Icon(FontAwesomeIcons.bars),
      onSelected: (MenuItem item) {
        switch (item) {
          case MenuItem.projects:
            Navigator.of(context).push(MaterialPageRoute<ProjectsScreen>(
              builder: (_) => const ProjectsScreen(),
            ));
            break;
          case MenuItem.reports:
            Navigator.of(context).push(MaterialPageRoute<ReportsScreen>(
              builder: (_) => const ReportsScreen(),
            ));
            break;
          case MenuItem.export:
            Navigator.of(context).push(MaterialPageRoute<ExportScreen>(
              builder: (_) => const ExportScreen(),
            ));
            break;
          case MenuItem.settings:
            Navigator.of(context).push(MaterialPageRoute<SettingsScreen>(
              builder: (_) => SettingsScreen(),
            ));
            break;
          case MenuItem.about:
            Navigator.of(context).push(MaterialPageRoute<AboutScreen>(
              builder: (_) => const AboutScreen(),
            ));
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            key: const Key("menuProjects"),
            value: MenuItem.projects,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.layerGroup),
              title: Text(L10N.of(context).tr.projects),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuReports"),
            value: MenuItem.reports,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.chartPie),
              title: Text(L10N.of(context).tr.reports),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuExport"),
            value: MenuItem.export,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.fileExport),
              title: Text(L10N.of(context).tr.exportImport),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuSettings"),
            value: MenuItem.settings,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.gear),
              title: Text(L10N.of(context).tr.settings),
            ),
          ),
          PopupMenuItem(
            key: const Key("menuAbout"),
            value: MenuItem.about,
            child: ListTile(
              leading: const Icon(FontAwesomeIcons.dna),
              title: Text(L10N.of(context).tr.about),
            ),
          ),
        ];
      },
    );
  }
}
