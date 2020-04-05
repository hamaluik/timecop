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

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  primaryColor: Colors.blueGrey[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.cyan[600],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'PublicSans',
  //scaffoldBackgroundColor: Colors.grey[100],
  scaffoldBackgroundColor: Colors.white,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.blueGrey[50],
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  primaryColor: Colors.grey[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.cyan[600],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'PublicSans',
  scaffoldBackgroundColor: Colors.grey[800],
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[850],
  ),
);

final ThemeData blackTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.cyan[600],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'PublicSans',
  scaffoldBackgroundColor: Colors.black,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.black,
  ),
);
