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

import 'dart:io';

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

  static final lightColors = ColorScheme.light(
      primary: Colors.cyan.shade600,
      onPrimary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black87,
      surface: Colors.grey.shade50,
      onSurface: Colors.black87,
      surfaceVariant: Colors.blueGrey.shade50,
      onSurfaceVariant: Colors.black87,
      error: Colors.red,
      onError: Colors.white);

  static final darkColors = ColorScheme.dark(
      primary: Colors.cyan.shade600,
      onPrimary: Colors.white,
      background: Colors.grey.shade800,
      onBackground: Colors.white,
      surface: Colors.grey.shade900,
      onSurface: Colors.white,
      surfaceVariant: const Color(0xFF303030),
      onSurfaceVariant: Colors.white,
      error: Colors.red,
      onError: Colors.white);

  static final _blackColors = ColorScheme.dark(
      primary: Colors.cyan.shade600,
      onPrimary: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      surfaceVariant: Colors.grey.shade900,
      onSurfaceVariant: Colors.white,
      error: Colors.red,
      onError: Colors.white);

  static final lightTheme = getThemeFromColors(
      brightness: Brightness.light,
      colors: lightColors,
      primarySwatch: Colors.blueGrey,
      appBarBackground: Colors.blueGrey.shade400,
      appBarForeground: Colors.white,
      appBarElevation: 0,
      appBarScrolledUnderElevation: 4);
  static final darkTheme = getThemeFromColors(
      brightness: Brightness.dark,
      colors: darkColors,
      primarySwatch: Colors.grey,
      appBarBackground: Colors.grey.shade800,
      appBarForeground: Colors.white,
      appBarElevation: 2,
      appBarScrolledUnderElevation: 4);
  static final blackTheme = getThemeFromColors(
      brightness: Brightness.dark,
      colors: _blackColors,
      primarySwatch: Colors.grey,
      appBarBackground: Colors.black,
      appBarForeground: Colors.white,
      appBarElevation: 0,
      appBarScrolledUnderElevation: 4);

  static Color getOnBackgroundLighter(BuildContext context) =>
      Theme.of(context).colorScheme.onBackground.withOpacity(0.62);

  static ThemeData getThemeFromColors(
          {required Brightness brightness,
          required ColorScheme colors,
          required Color appBarBackground,
          required Color appBarForeground,
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
              centerTitle: !Platform.isAndroid,
              elevation: appBarElevation,
              scrolledUnderElevation: appBarScrolledUnderElevation,
              shadowColor: Colors.black,
              backgroundColor: appBarBackground,
              foregroundColor: appBarForeground,
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
          dividerColor: colors.onBackground.withAlpha(31),
          dividerTheme:
              DividerThemeData(color: colors.onBackground.withAlpha(31)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              shape: const StadiumBorder(),
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: colors.onSurface)),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: colors.primary),
          switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                  (!states.contains(MaterialState.disabled) && states.contains(MaterialState.selected))
                      ? colors.primary
                      : null),
              trackColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                  (!states.contains(MaterialState.disabled) && states.contains(MaterialState.selected))
                      ? colors.primary.withAlpha(80)
                      : null)),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(MaterialState.disabled) &&
                        states.contains(MaterialState.selected))
                    ? colors.primary
                    : null),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(MaterialState.disabled) &&
                        states.contains(MaterialState.selected))
                    ? colors.primary
                    : null),
            checkColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(MaterialState.disabled) &&
                        states.contains(MaterialState.selected))
                    ? colors.onPrimary
                    : null),
          ));
}
