import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class CommonAppBar {
  CommonAppBar(
      {required this.context,
      required this.title,
      this.actionList = const [],
      this.leadingWidget});

  final BuildContext context;
  final String title;
  final List<Widget> actionList;
  Widget? leadingWidget;

  PreferredSizeWidget? appBar() {
    SmTextTheme.init(context);
    return AppBar(
      toolbarHeight: SmTextTheme.getResponsiveSize(context, 70),
      backgroundColor: SmAppTheme.isDarkMode(context)
          ? SmColorDarkTheme.primaryColor
          : SmColorLightTheme.primaryColor,
      actions: actionList,
      centerTitle: true,
      leading: leadingWidget,
      title: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                fontSize: SmTextTheme.getResponsiveSize(context, 20),
                color: SmAppTheme.isDarkMode(context)
                    ? SmColorDarkTheme.textColor
                    : SmColorLightTheme.textColor,
                fontWeight: FontWeight.w700,
              ))),
    );
  }
}
