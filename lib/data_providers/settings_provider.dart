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

import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider {
  final SharedPreferences _prefs;
  SettingsProvider(this._prefs)
    : assert(_prefs != null);

  bool getBool(String key) => _prefs.getBool(key);
  void setBool(String key, bool value) => _prefs.setBool(key, value);

  static Future<SettingsProvider> load() async {
    return SettingsProvider(await SharedPreferences.getInstance());
  }
}
