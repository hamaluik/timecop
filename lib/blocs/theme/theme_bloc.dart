import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/models/theme_type.dart';
import 'package:timecop/themes.dart';

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
