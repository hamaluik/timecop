part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeType? theme;
  const ThemeState(this.theme);
  @override
  List<Object?> get props => [theme];

  ThemeData? get themeData {
    switch (theme) {
      case ThemeType.auto:
        return null;
      case ThemeType.light:
        return ThemeUtil.lightTheme;
      case ThemeType.dark:
        return ThemeUtil.darkTheme;
      case ThemeType.black:
        return ThemeUtil.blackTheme;
      default:
        return null;
    }
  }
}
