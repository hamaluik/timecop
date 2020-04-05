part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();

  @override List<Object> get props => [];
}
