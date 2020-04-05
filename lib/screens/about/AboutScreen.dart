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
import 'package:timecop/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutPage(
      key: Key("aboutPage"),
      title: Text(L10N.of(context).tr.about),
      applicationVersion: 'v{{ version }}+{{ buildNumber }}',
      applicationDescription: Text(
        L10N.of(context).tr.appDescription,
        textAlign: TextAlign.justify,
      ),
      applicationIcon: SvgPicture.asset(
        "icon.no-bg.cyan.svg",
        semanticsLabel: L10N.of(context).tr.logoSemantics,
        height: 100,
      ),
      applicationLegalese: L10N.of(context).tr.appLegalese,
      children: <Widget>[
        MarkdownPageListTile(
          filename: 'README.md',
          title: Text(L10N.of(context).tr.readme),
          icon: Icon(FontAwesomeIcons.readme),
        ),
        MarkdownPageListTile(
          filename: 'CHANGELOG.md',
          title: Text(L10N.of(context).tr.changeLog),
          icon: Icon(FontAwesomeIcons.boxes),
        ),
        MarkdownPageListTile(
          filename: 'CONTRIBUTORS.md',
          title: Text(L10N.of(context).tr.contributors),
          icon: Icon(FontAwesomeIcons.userAstronaut),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.code),
          title: Text(L10N.of(context).tr.sourceCode),
          onTap: () => launch("https://github.com/hamaluik/timecop"),
        ),
        LicensesPageListTile(
          icon: Icon(FontAwesomeIcons.scroll),
        ),
      ],
    );
  }
}
