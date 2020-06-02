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
  ThemeBloc(this.settings);

  @override
  ThemeState get initialState => ThemeState(ThemeType.auto);

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is LoadThemeEvent) {
      yield ThemeState(settings.getTheme());
    } else if (event is ChangeThemeEvent) {
      settings.setTheme(event.theme);
      yield ThemeState(event.theme);
    }
  }
}
