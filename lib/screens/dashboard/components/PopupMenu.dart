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
import 'package:timecop/screens/about/AboutScreen.dart';
import 'package:timecop/screens/export/ExportScreen.dart';
import 'package:timecop/screens/projects/ProjectsScreen.dart';

enum MenuItem {
  projects, export, about,
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      icon: Icon(FontAwesomeIcons.dungeon),
      onSelected: (MenuItem item) {
        switch(item) {
          case MenuItem.projects:
            Navigator.of(context).push(MaterialPageRoute<ProjectsScreen>(
              builder: (BuildContext _context) => ProjectsScreen(),
            ));
            break;
          case MenuItem.export:
            Navigator.of(context).push(MaterialPageRoute<ExportScreen>(
              builder: (BuildContext _context) => ExportScreen(),
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
            child: ListTile(
              leading: Icon(FontAwesomeIcons.layerGroup),
              title: Text("Projects"),
            ),
            value: MenuItem.projects,
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.fileExport),
              title: Text("Export"),
            ),
            value: MenuItem.export,
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.dna),
              title: Text("About"),
            ),
            value: MenuItem.about,
          ),
        ];
      },
    );
  }
}