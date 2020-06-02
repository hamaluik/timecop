part of 'locale_bloc.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
}

class LoadLocaleEvent extends LocaleEvent {
  const LoadLocaleEvent();
  @override
  List<Object> get props => [];
}

class ChangeLocaleEvent extends LocaleEvent {
  final Locale locale;
  const ChangeLocaleEvent(this.locale);
  @override
  List<Object> get props => [locale];
}
