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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutPage(
      title: Text('About'),
      applicationVersion: 'Version {{ version }}, build #{{ buildNumber }}',
      applicationDescription: Text(
        'A time tracking app that respects your privacy and the gets the job done without being fancy.',
        textAlign: TextAlign.justify,
      ),
      applicationIcon: FlutterLogo(size: 100),
      applicationLegalese: 'Copyright © Kenton Hamaluik, {{ year }}',
      children: <Widget>[
        MarkdownPageListTile(
          filename: 'README.md',
          title: Text('View Readme'),
          icon: Icon(FontAwesomeIcons.readme),
        ),
        MarkdownPageListTile(
          filename: 'CHANGELOG.md',
          title: Text('View Changelog'),
          icon: Icon(FontAwesomeIcons.boxes),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.scroll),
          title: Text('View License'),
          onTap: () {
            // TODO: properly render the text of the LICENSE file
          },
        ),
        LicensesPageListTile(
          icon: Icon(FontAwesomeIcons.glassCheers),
        ),
      ],
    );
  }
}