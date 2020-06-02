import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final SettingsProvider settings;
  LocaleBloc(this.settings);

  @override
  LocaleState get initialState => LocaleState(null);

  @override
  Stream<LocaleState> mapEventToState(
    LocaleEvent event,
  ) async* {
    if (event is LoadLocaleEvent) {
      yield LocaleState(settings.getLocale());
    } else if (event is ChangeLocaleEvent) {
      settings.setLocale(event.locale);
      yield LocaleState(event.locale);
    }
  }
}
