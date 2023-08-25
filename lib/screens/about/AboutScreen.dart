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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timecop/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data as PackageInfo;
          String version = packageInfo.version;
          String buildNumber = packageInfo.buildNumber;
          return AboutPage(
            key: const Key("aboutPage"),
            title: Text(L10N.of(context).tr.about),
            applicationVersion: "v$version+$buildNumber",
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
                icon: const Icon(FontAwesomeIcons.readme),
              ),
              MarkdownPageListTile(
                filename: 'CHANGELOG.md',
                title: Text(L10N.of(context).tr.changeLog),
                icon: const Icon(FontAwesomeIcons.boxesStacked),
              ),
              MarkdownPageListTile(
                filename: 'CONTRIBUTORS.md',
                title: Text(L10N.of(context).tr.contributors),
                icon: const Icon(FontAwesomeIcons.userAstronaut),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.globe),
                title: Text(L10N.of(context).tr.translate),
                onTap: () => launchUrl(
                    Uri.parse("https://hosted.weblate.org/projects/timecop/")),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.code),
                title: Text(L10N.of(context).tr.sourceCode),
                onTap: () =>
                    launchUrl(Uri.parse("https://github.com/hamaluik/timecop")),
              ),
              const LicensesPageListTile(
                icon: Icon(FontAwesomeIcons.scroll),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
