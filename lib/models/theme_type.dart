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

import 'package:flutter/cupertino.dart';
import 'package:timecop/l10n.dart';

enum ThemeType {
  auto,
  light,
  dark,
  black,
  autoMaterialYou,
  lightMaterialYou,
  darkMaterialYou;

  String? get stringify {
    switch (this) {
      case ThemeType.auto:
        return "auto";
      case ThemeType.light:
        return "light";
      case ThemeType.dark:
        return "dark";
      case ThemeType.black:
        return "black";
      case ThemeType.autoMaterialYou:
        return "autoMaterialYou";
      case ThemeType.lightMaterialYou:
        return "lightMaterialYou";
      case ThemeType.darkMaterialYou:
        return "darkMaterialYou";
    }
  }

  String? display(BuildContext context) {
    switch (this) {
      case ThemeType.auto:
        return L10N.of(context).tr.auto;
      case ThemeType.light:
        return L10N.of(context).tr.light;
      case ThemeType.dark:
        return L10N.of(context).tr.dark;
      case ThemeType.black:
        return L10N.of(context).tr.black;
      case ThemeType.autoMaterialYou:
        return L10N.of(context).tr.autoMaterialYou;
      case ThemeType.lightMaterialYou:
        return L10N.of(context).tr.lightMaterialYou;
      case ThemeType.darkMaterialYou:
        return L10N.of(context).tr.darkMaterialYou;
      default:
        return null;
    }
  }

  static ThemeType fromString(String? type) {
    if (type == null) return ThemeType.auto;
    switch (type) {
      case "auto":
        return ThemeType.auto;
      case "light":
        return ThemeType.light;
      case "dark":
        return ThemeType.dark;
      case "black":
        return ThemeType.black;
      case "autoMaterialYou":
        return ThemeType.autoMaterialYou;
      case "lightMaterialYou":
        return ThemeType.lightMaterialYou;
      case "darkMaterialYou":
        return ThemeType.darkMaterialYou;
      default:
        return ThemeType.auto;
    }
  }
}
