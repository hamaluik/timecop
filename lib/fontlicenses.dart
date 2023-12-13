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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<LicenseEntry> _license(String library, String path) async {
  String text = await rootBundle.loadString(path);
  LicenseEntry lic = LicenseEntryWithLineBreaks(<String>[library], text);
  return lic;
}

Stream<LicenseEntry> getFontLicenses() {
  return Stream.fromFutures([
    _license("Public Sans", "fonts/LICENSE-PublicSans.md"),
    _license("Public Sans - OFL", "fonts/LICENSE-PublicSans.txt"),
  ]);
}
