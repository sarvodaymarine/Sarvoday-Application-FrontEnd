import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class DrawerWidget extends StatelessWidget {
  final List<String> drawerList = [
    "Employees",
    "Clients",
    "Services",
    "Port Locations"
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: SmAppTheme.isDarkMode(context)
                    ? SmColorDarkTheme.onPrimary
                    : SmColorLightTheme.onPrimary,
              ),
              child: Center(
                child: RichText(
                    text: TextSpan(
                        text: "Sarvoday Marine",
                        style: SmTextTheme.labelStyle2(context))),
              ),
            ),
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: drawerList.length,
              itemBuilder: (context, item) {
                return ListTile(
                    hoverColor: SmAppTheme.isDarkMode(context)
                        ? SmColorDarkTheme.primaryLightColor
                        : SmColorLightTheme.primaryLightColor,
                    onTap: () => onTapHandle(context, drawerList[item]),
                    title: RichText(
                        text: TextSpan(
                            text: drawerList[item],
                            style: SmTextTheme.confirmButtonTextStyle(context)
                                .copyWith(
                                    fontSize: SmTextTheme.getResponsiveSize(
                                        context, 16)))));
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void onTapHandle(BuildContext context, String tileValue) {
    switch (tileValue) {
      case "Employees":
        Navigator.of(context).pop();
        context.router.push(EmployeeListRoute());
        break;
      case "Clients":
        Navigator.of(context).pop();
        context.router.push(ClientListRoute());
        break;
      case "Services":
        Navigator.of(context).pop();
        context.router.push(ServicesListRoute());
        break;
      case "Port Locations":
        Navigator.of(context).pop();
        context.router.push(LocationListRoute());
        break;
      default:
        Navigator.of(context).pop();
        break;
    }
  }
}
