import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class CustomSmButton extends StatelessWidget {
  const CustomSmButton(
      {super.key,
      required this.text,
      this.fontSize,
      this.color,
      required this.onTap});

  final String text;
  final double? fontSize;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ??
            (SmAppTheme.isDarkMode(context)
                ? SmColorDarkTheme.primaryColor
                : SmColorLightTheme.primaryColor),
        padding: EdgeInsets.symmetric(
            vertical: SmTextTheme.getResponsiveSize(context, 8.0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              SmTextTheme.getResponsiveSize(context, 20.0)),
        ),
      ),
      child: RichText(
          text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize ?? 24, fontWeight: FontWeight.bold),
      )),
    );
  }
}
