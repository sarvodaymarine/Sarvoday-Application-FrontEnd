import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';

class SmAppTheme {
  static bool isDarkMode(BuildContext context) {
    return false /*MediaQuery.of(context).platformBrightness == Brightness.dark*/;
  }

  static final lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(),
      fontFamily: 'SourceSans',
      actionIconTheme: const ActionIconThemeData(),
      brightness: Brightness.light,
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          )),
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          onSurface: SmColorLightTheme.textColor,
          surface: SmColorLightTheme.backgroundColor,
          onError: SmColorLightTheme.textColor,
          primary: SmColorLightTheme.primaryColor,
          secondary: SmCommonColors.secondaryColor,
          error: SmCommonColors.errorColor,
          onPrimary: SmColorLightTheme.onPrimary,
          onSecondary: SmColorLightTheme.onSecondary));

  static final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(),
      fontFamily: 'SourceSans',
      actionIconTheme: const ActionIconThemeData(),
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          onSurface: SmColorDarkTheme.textColor,
          surface: SmColorDarkTheme.backgroundColor,
          onError: SmColorDarkTheme.textColor,
          primary: SmColorDarkTheme.primaryColor,
          secondary: SmCommonColors.secondaryColor,
          error: SmCommonColors.errorColor,
          onPrimary: SmColorDarkTheme.onPrimary,
          onSecondary: SmColorDarkTheme.textColor));
}
