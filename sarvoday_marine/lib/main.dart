import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/navigation/app_route.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/service_module/service_module_injection_container.dart'
    as servicedl;
import 'package:sarvoday_marine/features/location_module/location_injection_container.dart'
    as locationdl;
import 'package:sarvoday_marine/features/authentication_module/authentication_injection_container.dart'
    as authenticationdl;
import 'package:sarvoday_marine/features/client_module/client_module_injection_container.dart'
    as clientdl;
import 'package:sarvoday_marine/features/calendar_module/calendar_injection_container.dart'
    as calendardl;
import 'package:sarvoday_marine/features/employee_module/employee_injection_container.dart'
    as employeedl;

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await servicedl.init();
  await employeedl.init();
  await authenticationdl.init();
  await locationdl.init();
  await clientdl.init();
  await calendardl.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: StringConst.appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: _router.config(),
      theme: SmAppTheme.lightTheme,
      // darkTheme: SmAppTheme.darkTheme,
      // routerDelegate: _router.delegate(context),
      // routeInformationParser: _router.defaultRouteParser(),
    );
  }
}
