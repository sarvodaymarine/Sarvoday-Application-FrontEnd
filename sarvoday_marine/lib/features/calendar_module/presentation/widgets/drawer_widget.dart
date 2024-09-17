import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/api_handler/token_manager.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/drawer_cubit.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key, required this.userRole});

  final String userRole;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final List<Map<String, dynamic>> drawerItems = [
    {"title": "Employees", "icon": Icons.people},
    {"title": "Clients", "icon": Icons.business},
    {"title": "Services", "icon": Icons.build},
    {"title": "Port Locations", "icon": Icons.location_on},
    {"title": "Logout", "icon": Icons.logout},
  ];

  @override
  void initState() {
    if (widget.userRole == "client" || widget.userRole == "employee") {
      drawerItems.removeRange(0, 4);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: BlocBuilder<DrawerCubit, bool>(
        builder: (context, isCollapsed) {
          return Drawer(
            width: isCollapsed
                ? MediaQuery.of(context).size.width * 0.18
                : MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: SmAppTheme.isDarkMode(context)
                        ? SmColorDarkTheme.onPrimary
                        : SmColorLightTheme.onPrimary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isCollapsed)
                        Flexible(
                          child: Text(
                            "Sarvoday Marine",
                            style: SmTextTheme.labelStyle2(context),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          context.read<DrawerCubit>().toggleDrawer();
                        },
                        child: SizedBox(
                          width: SmTextTheme.getResponsiveSize(context, 20),
                          child: Icon(
                            isCollapsed ? Icons.arrow_right : Icons.arrow_left,
                            color: SmAppTheme.isDarkMode(context)
                                ? SmColorDarkTheme.primaryDarkColor
                                : SmColorLightTheme.primaryDarkColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: drawerItems.length,
                    itemBuilder: (context, index) {
                      final item = drawerItems[index];
                      return ListTile(
                        leading: Icon(
                          item['icon'],
                          color: SmAppTheme.isDarkMode(context)
                              ? SmColorDarkTheme.primaryLightColor
                              : SmColorLightTheme.primaryLightColor,
                        ),
                        title: isCollapsed
                            ? null
                            : Text(
                                item['title'],
                                style:
                                    SmTextTheme.confirmButtonTextStyle(context)
                                        .copyWith(
                                  fontSize: SmTextTheme.getResponsiveSize(
                                      context, 16),
                                ),
                              ),
                        hoverColor: SmAppTheme.isDarkMode(context)
                            ? SmColorDarkTheme.primaryLightColor
                            : SmColorLightTheme.primaryLightColor,
                        onTap: () => onTapHandle(context, item['title']),
                      );
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> onTapHandle(BuildContext context, String tileValue) async {
    Navigator.of(context).pop();

    switch (tileValue) {
      case "Employees":
        context.router.push(EmployeeListRoute());
        break;
      case "Clients":
        context.router.push(ClientListRoute());
        break;
      case "Services":
        context.router.push(ServicesListRoute());
        break;
      case "Port Locations":
        context.router.push(LocationListRoute());
        break;
      case "Logout":
        await TokenManager.clearToken();
        if (context.mounted) {
          context.router.replaceAll([SignInRoute()]);
          CommonMethods.showToast(context, 'Logout Successfully');
          await TokenManager.clearToken();
        }
        break;
      default:
        break;
    }
  }
}
