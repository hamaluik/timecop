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

  static final lightTheme = ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      pageTransitionsTheme: _pageTransitionsTheme,
      primarySwatch: _lightPrimarySwatch,
      scaffoldBackgroundColor: _lightColors.background,
      appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 4,
          shadowColor: Colors.black,
          backgroundColor: _lightAppBarBackground,
          foregroundColor: _lightColors.onPrimary,
          surfaceTintColor: Colors.transparent),
      fontFamily: _fontFamily,
      colorScheme: _lightColors,
      primaryColor: _lightColors.primary,
      listTileTheme:
          ListTileThemeData(iconColor: _lightColors.onSurfaceVariant),
      expansionTileTheme: ExpansionTileThemeData(
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          collapsedTextColor: _lightColors.onBackground,
          textColor: _lightColors.onSurface,
          iconColor: _lightColors.onSurfaceVariant,
          collapsedIconColor: _lightColors.onSurfaceVariant),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: _lightBottomSheetBackground,
      ),
      dividerColor: _lightColors.onBackground.withAlpha(31),
      dividerTheme:
          DividerThemeData(color: _lightColors.onBackground.withAlpha(31)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: const CircleBorder(),
          backgroundColor: _lightColors.secondary,
          foregroundColor: _lightColors.onSecondary),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: _lightColors.onSurface)),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: _lightColors.secondary),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _lightColors.onPrimary)),
      ),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? _lightColors.secondary
                  : null),
          trackColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? _lightColors.secondary.withAlpha(80)
                  : null)),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? _lightColors.secondary
                : null),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? _lightColors.secondary
                : null),
      ));

  static final darkTheme = ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      pageTransitionsTheme: _pageTransitionsTheme,
      primarySwatch: _darkPrimarySwatch,
      scaffoldBackgroundColor: _darkColors.background,
      appBarTheme: AppBarTheme(
          elevation: 2,
          scrolledUnderElevation: 4,
          shadowColor: Colors.black,
          backgroundColor: _darkAppBarBackground,
          foregroundColor: _darkColors.onPrimary,
          surfaceTintColor: Colors.transparent),
      fontFamily: _fontFamily,
      colorScheme: _darkColors,
      primaryColor: _darkColors.primary,
      listTileTheme: ListTileThemeData(iconColor: _darkColors.onSurfaceVariant),
      expansionTileTheme: ExpansionTileThemeData(
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          collapsedTextColor: _darkColors.onBackground,
          textColor: _darkColors.onSurface,
          iconColor: _darkColors.onSurfaceVariant,
          collapsedIconColor: _darkColors.onSurfaceVariant),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkBottomSheetBackground,
      ),
      dividerColor: _darkColors.onBackground.withAlpha(31),
      dividerTheme:
          DividerThemeData(color: _darkColors.onBackground.withAlpha(31)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: const CircleBorder(),
          backgroundColor: _darkColors.secondary,
          foregroundColor: _darkColors.onSecondary),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: _darkColors.onSurface)),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: _darkColors.secondary),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _darkColors.onPrimary))),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? _darkColors.secondary
                  : null),
          trackColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? _darkColors.secondary.withAlpha(80)
                  : null)),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? _darkColors.secondary
                : null),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? _darkColors.secondary
                : null),
      ));

  static final blackTheme = ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      pageTransitionsTheme: _pageTransitionsTheme,
      primarySwatch: _blackPrimarySwatch,
      scaffoldBackgroundColor: _blackColors.background,
      appBarTheme: AppBarTheme(
          backgroundColor: _blackAppBarBackground,
          foregroundColor: _blackColors.onPrimary,
          surfaceTintColor: Colors.transparent),
      fontFamily: _fontFamily,
      colorScheme: _blackColors,
      primaryColor: _blackColors.primary,
      listTileTheme:
          ListTileThemeData(iconColor: _blackColors.onSurfaceVariant),
      expansionTileTheme: ExpansionTileThemeData(
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          collapsedTextColor: _blackColors.onBackground,
          textColor: _blackColors.onSurface,
          iconColor: _blackColors.onSurfaceVariant,
          collapsedIconColor: _blackColors.onSurfaceVariant),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _blackBottomSheetBackground,
      ),
      dividerColor: _blackColors.onBackground.withAlpha(31),
      dividerTheme:
          DividerThemeData(color: _blackColors.onBackground.withAlpha(31)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: const CircleBorder(),
          backgroundColor: _blackColors.secondary,
          foregroundColor: _blackColors.onSecondary),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: _blackColors.onSurface)),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: _blackColors.secondary),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _blackColors.onPrimary))),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? _blackColors.secondary
                  : null),
          trackColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              (!states.contains(MaterialState.disabled) &&
                      states.contains(MaterialState.selected))
                  ? _blackColors.secondary.withAlpha(80)
                  : null)),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? _blackColors.secondary
                : null),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
            (!states.contains(MaterialState.disabled) &&
                    states.contains(MaterialState.selected))
                ? _blackColors.secondary
                : null),
      ));
}
