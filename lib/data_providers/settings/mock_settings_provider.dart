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

// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/rendering.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/models/theme_type.dart';

class MockSettingsProvider extends SettingsProvider {
  late Map<String, dynamic> values;
  ThemeType? theme;
  Locale? locale;

  MockSettingsProvider() {
    values = <String, dynamic>{};
    theme = ThemeType.auto;
  }

  @override
  bool? getBool(String key) =>
      values.containsKey(key) ? values[key] as bool? : true;

  @override
  Future<void> setBool(String key, bool? value) async => values[key] = value;

  @override
  int? getInt(String key) => values.containsKey(key) ? values[key] as int? : -1;

  @override
  Future<void> setInt(String key, int value) async => values[key] = value;

  @override
  ThemeType? getTheme() => theme;

  @override
  Future<void> setTheme(ThemeType? t) async => theme = t;

  @override
  Locale? getLocale() => locale;

  @override
  Future<void> setLocale(Locale? l) async => locale = l;
}
