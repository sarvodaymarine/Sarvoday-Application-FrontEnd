import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';

class CustomSmCardView extends StatelessWidget {
  const CustomSmCardView({
    super.key,
    /* required this.child*/
  });

  // final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), side: BorderSide.none),
      shadowColor: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.onSecondary
          : SmColorLightTheme.onSecondary,
      color: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.primaryLightColor
          : SmColorLightTheme.primaryLightColor,
      child: RichText(
          text: TextSpan(
              text: StringConst.signIn,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: SmAppTheme.isDarkMode(context)
                      ? SmColorDarkTheme.textColor
                      : SmColorLightTheme.textColor))),
    );
  }
}
