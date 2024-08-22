import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class CommonFloatingAction {
  CommonFloatingAction({required this.context, required this.onPressed});

  final BuildContext context;
  final VoidCallback onPressed;

  Widget? addActionButton() {
    SmTextTheme.init(context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 12.0)),
        child: IconButton(
            icon: Icon(
              Icons.add,
              color: SmColorDarkTheme.textColor,
              size: SmTextTheme.getResponsiveSize(context, 18),
            ),
            style: IconButton.styleFrom(
              backgroundColor: SmAppTheme.isDarkMode(context)
                  ? SmColorDarkTheme.primaryColor
                  : SmColorLightTheme.primaryColor,
              padding: EdgeInsets.symmetric(
                  horizontal: SmTextTheme.getResponsiveSize(context, 12.0),
                  vertical: SmTextTheme.getResponsiveSize(context, 12.0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    SmTextTheme.getResponsiveSize(context, 8.0)),
              ),
            ),
            onPressed: onPressed),
      ),
    );
  }
}
