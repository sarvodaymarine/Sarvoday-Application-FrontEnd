import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';

class SmTextTheme {
  static double? _screenWidth;
  static double? _screenHeight;

  static void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
  }

  static double getResponsiveSize(BuildContext context, double baseFontSize) {
    final textScaler = MediaQuery.of(context).textScaler;
    // Adjust the multiplier based on your design requirements
    return textScaler.scale(baseFontSize) *
        ((_screenWidth ?? MediaQuery.of(context).size.width) / 360);
  }

  static TextStyle labelStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w700,
      fontSize: getResponsiveSize(context, 30),
    );
  }

  static TextStyle labelStyle2(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w700,
      fontSize: getResponsiveSize(context, 24),
    );
  }

  static TextStyle labelStyle3(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w700,
      fontSize: getResponsiveSize(context, 20),
    );
  }

  static TextStyle unselectedLabelStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.secondaryTextColor
          : SmColorLightTheme.secondaryTextColor,
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveSize(context, 20),
    );
  }

  static TextStyle labelNameTextStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.bold,
      fontSize: getResponsiveSize(context, 48),
    );
  }

  static TextStyle labelDetails(BuildContext context) {
    return TextStyle(
      height: 1.5,
      fontSize: getResponsiveSize(context, 16),
    );
  }

  static TextStyle confirmButtonTextStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.primaryColor
          : SmColorLightTheme.primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveSize(context, 20),
      letterSpacing: 1.18,
    );
  }

  static TextStyle cancelButtonTextStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveSize(context, 20),
      letterSpacing: 1.18,
    );
  }

  static TextStyle labelDescriptionStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w400,
      fontSize: getResponsiveSize(context, 16),
    );
  }

  static TextStyle infoLabelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontSize: getResponsiveSize(context, 20),
    );
  }

  static TextStyle infoContentStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: getResponsiveSize(context, 16),
    );
  }

  static TextStyle hintTextStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.secondaryTextColor
          : SmColorLightTheme.secondaryTextColor,
      fontWeight: FontWeight.w400,
      fontSize: getResponsiveSize(context, 10),
    );
  }

  static TextStyle infoContentStyle2(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.onPrimary
          : SmColorLightTheme.onPrimary,
      fontWeight: FontWeight.w700,
      fontSize: getResponsiveSize(context, 16),
    );
  }

  static TextStyle infoContentStyle3(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w700,
      fontSize: getResponsiveSize(context, 16),
    );
  }

  static TextStyle infoContentStyle4(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.primaryColor
          : SmColorLightTheme.primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveSize(context, 12),
    );
  }

  static TextStyle infoContentStyle5(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.primaryDarkColor
          : SmColorLightTheme.primaryDarkColor,
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveSize(context, 10),
    );
  }

  static TextStyle infoContentStyle6(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w400,
      fontSize: getResponsiveSize(context, 10),
    );
  }

  static TextStyle textInputStyle(BuildContext context) {
    return TextStyle(
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.textColor
          : SmColorLightTheme.textColor,
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveSize(context, 12),
    );
  }
}
