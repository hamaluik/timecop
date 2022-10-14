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

class ThemeUtil {
  static final lightColors = ColorScheme.light(
      primary: Colors.blueGrey.shade900,
      onPrimary: Colors.white,
      secondary: Colors.cyan.shade600,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black87,
      surface: Colors.grey.shade50,
      onSurface: Colors.black87);

  static final darkColors = ColorScheme.dark(
      primary: Colors.grey.shade900,
      onPrimary: Colors.white,
      secondary: Colors.cyan.shade600,
      onSecondary: Colors.white,
      background: Colors.grey.shade800,
      onBackground: Colors.white,
      surface: Colors.grey.shade900,
      onSurface: Colors.white);

  static final blackColors = ColorScheme.dark(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.cyan.shade600,
      onSecondary: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white);

  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey.shade900,
      primaryColorBrightness: Brightness.dark,
      accentColor: Colors.cyan.shade600,
      accentColorBrightness: Brightness.dark,
      colorScheme: lightColors,
      fontFamily: 'PublicSans',
      //scaffoldBackgroundColor: Colors.grey.shade100,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey.shade400),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.blueGrey.shade50,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: lightColors.onSurface)),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: lightColors.secondary),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: lightColors.onPrimary))));

  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      primaryColor: Colors.grey.shade900,
      primaryColorBrightness: Brightness.dark,
      accentColor: Colors.cyan.shade600,
      accentColorBrightness: Brightness.dark,
      colorScheme: darkColors,
      fontFamily: 'PublicSans',
      scaffoldBackgroundColor: Colors.grey.shade800,
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF303030),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: darkColors.onSurface)),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: darkColors.secondary),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: darkColors.onPrimary))));

  static final blackTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      primaryColorBrightness: Brightness.dark,
      accentColor: Colors.cyan.shade600,
      accentColorBrightness: Brightness.dark,
      colorScheme: blackColors,
      fontFamily: 'PublicSans',
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: blackColors.onSurface)),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: blackColors.secondary),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: blackColors.onPrimary))));
}
