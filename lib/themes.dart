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
  static const _pageTransitionsTheme =
      PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder()
  });
  static const _fontFamily = 'PublicSans';

  static final _lightColors = ColorScheme.light(
      primary: Colors.blueGrey.shade900,
      onPrimary: Colors.white,
      secondary: Colors.cyan.shade600,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black87,
      surface: Colors.grey.shade50,
      onSurface: Colors.black87,
      onSurfaceVariant: Colors.black54,
      error: Colors.red,
      onError: Colors.white);
  static const _lightPrimarySwatch = Colors.blueGrey;
  static final _lightAppBarBackground = Colors.blueGrey.shade400;
  static final _lightBottomSheetBackground = Colors.blueGrey.shade50;

  static final _darkColors = ColorScheme.dark(
      primary: Colors.grey.shade900,
      onPrimary: Colors.white,
      secondary: Colors.cyan.shade600,
      onSecondary: Colors.white,
      background: Colors.grey.shade800,
      onBackground: Colors.white,
      surface: Colors.grey.shade900,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.grey.shade400,
      error: Colors.red,
      onError: Colors.white);
  static const _darkPrimarySwatch = Colors.grey;
  static final _darkAppBarBackground = Colors.grey.shade800;
  static const _darkBottomSheetBackground = Color(0xFF303030);

  static final _blackColors = ColorScheme.dark(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.cyan.shade600,
      onSecondary: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.grey.shade400,
      error: Colors.red,
      onError: Colors.white);
  static const _blackPrimarySwatch = Colors.grey;
  static final _blackAppBarBackground = Colors.grey.shade900;
  static const _blackBottomSheetBackground = Colors.black;

  static final lightTheme = getThemeFromColors(
      brightness: Brightness.light,
      colors: _lightColors,
      primarySwatch: _lightPrimarySwatch,
      bottomSheetBackground: _lightBottomSheetBackground,
      appBarBackground: _lightAppBarBackground,
      appBarElevation: 0,
      appBarScrolledUnderElevation: 4);
  static final darkTheme = getThemeFromColors(
      brightness: Brightness.dark,
      colors: _darkColors,
      primarySwatch: _darkPrimarySwatch,
      bottomSheetBackground: _darkBottomSheetBackground,
      appBarBackground: _darkAppBarBackground,
      appBarElevation: 2,
      appBarScrolledUnderElevation: 4);
  static final blackTheme = getThemeFromColors(
      brightness: Brightness.dark,
      colors: _blackColors,
      primarySwatch: _blackPrimarySwatch,
      bottomSheetBackground: _blackBottomSheetBackground,
      appBarBackground: _blackAppBarBackground,
      appBarElevation: 0,
      appBarScrolledUnderElevation: 0);

  static ThemeData getThemeFromColors(
          {required Brightness brightness,
          required ColorScheme colors,
          required Color bottomSheetBackground,
          required Color appBarBackground,
          double appBarElevation = 0,
          double appBarScrolledUnderElevation = 4,
          MaterialColor? primarySwatch}) =>
      ThemeData(
          useMaterial3: false,
          brightness: brightness,
          pageTransitionsTheme: _pageTransitionsTheme,
          primarySwatch: primarySwatch,
          scaffoldBackgroundColor: colors.background,
          appBarTheme: AppBarTheme(
              elevation: appBarElevation,
              scrolledUnderElevation: appBarScrolledUnderElevation,
              shadowColor: Colors.black,
              backgroundColor: appBarBackground,
              foregroundColor: colors.onPrimary,
              surfaceTintColor: Colors.transparent),
          fontFamily: _fontFamily,
          colorScheme: colors,
          primaryColor: colors.primary,
          listTileTheme: ListTileThemeData(iconColor: colors.onSurfaceVariant),
          expansionTileTheme: ExpansionTileThemeData(
              collapsedBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              collapsedTextColor: colors.onBackground,
              textColor: colors.onSurface,
              iconColor: colors.onSurfaceVariant,
              collapsedIconColor: colors.onSurfaceVariant),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: bottomSheetBackground,
          ),
          dividerColor: colors.onBackground.withAlpha(31),
          dividerTheme:
              DividerThemeData(color: colors.onBackground.withAlpha(31)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              shape: const CircleBorder(),
              backgroundColor: colors.secondary,
              foregroundColor: colors.onSecondary),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: colors.onSurface)),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: colors.secondary),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.onPrimary)),
          ),
          switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                  (!states.contains(MaterialState.disabled) && states.contains(MaterialState.selected))
                      ? colors.secondary
                      : null),
              trackColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                  (!states.contains(MaterialState.disabled) && states.contains(MaterialState.selected))
                      ? colors.secondary.withAlpha(80)
                      : null)),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(MaterialState.disabled) &&
                        states.contains(MaterialState.selected))
                    ? colors.secondary
                    : null),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(MaterialState.disabled) &&
                        states.contains(MaterialState.selected))
                    ? colors.secondary
                    : null),
          ));
}
