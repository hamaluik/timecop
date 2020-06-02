part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeType theme;
  ThemeState(this.theme);
  @override
  List<Object> get props => [theme];

  ThemeData get themeData {
    switch (theme) {
      case ThemeType.auto:
        return null;
      case ThemeType.light:
        return lightTheme;
      case ThemeType.dark:
        return darkTheme;
      case ThemeType.black:
        return blackTheme;
    }
    return null;
  }
}
