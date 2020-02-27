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

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timecop/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => ThemeState(
        brightness: WidgetsBinding.instance.window.platformBrightness,
        theme: WidgetsBinding.instance.window.platformBrightness ==
                Brightness.light
            ? lightTheme
            : darkTheme,
      );

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is BrightnessChanged) {
      switch (event.brightness) {
        case Brightness.dark:
          {
            yield ThemeState(brightness: Brightness.dark, theme: darkTheme);
            break;
          }
        case Brightness.light:
          {
            yield ThemeState(
                brightness: Brightness.light, theme: lightTheme);
            break;
          }
      }
    }
  }
}
