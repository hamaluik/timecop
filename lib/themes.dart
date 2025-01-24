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
      surface: Colors.grey.shade50,
      onSurface: Colors.black87,
      surfaceContainerHighest: Colors.blueGrey.shade50,
      onSurfaceVariant: Colors.black87,
      error: Colors.red,
      onError: Colors.white);

  static final darkColors = ColorScheme.dark(
      primary: Colors.cyan.shade600,
      onPrimary: Colors.white,
      surface: Colors.grey.shade900,
      onSurface: Colors.white,
      surfaceContainerHighest: const Color(0xFF303030),
      onSurfaceVariant: Colors.white,
      error: Colors.red,
      onError: Colors.white);

  static final _blackColors = ColorScheme.dark(
      primary: Colors.cyan.shade600,
      onPrimary: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      surfaceContainerHighest: Colors.grey.shade900,
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
      Theme.of(context).colorScheme.onSurface.withOpacity(0.62);

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
          scaffoldBackgroundColor: colors.surface,
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
              collapsedTextColor: colors.onSurface,
              textColor: colors.onSurface,
              iconColor: colors.onSurfaceVariant,
              collapsedIconColor: colors.onSurfaceVariant),
          dividerColor: colors.onSurface.withAlpha(31),
          dividerTheme:
              DividerThemeData(color: colors.onSurface.withAlpha(31)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              shape: const StadiumBorder(),
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: colors.onSurface)),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: colors.primary),
          switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color?>((states) =>
                  (!states.contains(WidgetState.disabled) && states.contains(WidgetState.selected))
                      ? colors.primary
                      : null),
              trackColor: WidgetStateProperty.resolveWith<Color?>((states) =>
                  (!states.contains(WidgetState.disabled) && states.contains(WidgetState.selected))
                      ? colors.primary.withAlpha(80)
                      : null)),
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(WidgetState.disabled) &&
                        states.contains(WidgetState.selected))
                    ? colors.primary
                    : null),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(WidgetState.disabled) &&
                        states.contains(WidgetState.selected))
                    ? colors.primary
                    : null),
            checkColor: WidgetStateProperty.resolveWith<Color?>((states) =>
                (!states.contains(WidgetState.disabled) &&
                        states.contains(WidgetState.selected))
                    ? colors.onPrimary
                    : null),
          ));
}
