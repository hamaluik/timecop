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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/models/theme_type.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SettingsProvider settings;
  ThemeBloc(this.settings) : super(const ThemeState(ThemeType.auto)) {
    on<LoadThemeEvent>((event, emit) {
      emit(ThemeState(settings.getTheme()));
    });

    on<ChangeThemeEvent>((event, emit) {
      settings.setTheme(event.theme);
      emit(ThemeState(event.theme));
    });
  }
}
