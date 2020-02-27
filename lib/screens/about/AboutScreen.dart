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

import 'package:about/about.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutPage(
      title: Text('About'),
      applicationVersion: 'v{{ version }}-{{ buildNumber }}',
      applicationDescription: Text(
        'A time tracking app that respects your privacy and gets the job done without being fancy.',
        textAlign: TextAlign.justify,
      ),
      applicationIcon: SvgPicture.asset(
        "icon.no-bg.pink.svg",
        semanticsLabel: "Time Cop Logo",
        height: 100,
      ),
      applicationLegalese: 'Copyright © Kenton Hamaluik, {{ year }}',
      children: <Widget>[
        MarkdownPageListTile(
          filename: 'README.md',
          title: Text('Readme'),
          icon: Icon(FontAwesomeIcons.readme),
        ),
        MarkdownPageListTile(
          filename: 'CHANGELOG.md',
          title: Text('Changelog'),
          icon: Icon(FontAwesomeIcons.boxes),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.code),
          title: Text("Source Code"),
          onTap: () => launch("https://github.com/hamaluik/timecop"),
        ),
        LicensesPageListTile(
          icon: Icon(FontAwesomeIcons.scroll),
        ),
      ],
    );
  }
}