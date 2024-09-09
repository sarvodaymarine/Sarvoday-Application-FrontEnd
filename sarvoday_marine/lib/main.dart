import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/navigation/app_route.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/service_module/service_module_injection_container.dart'
    as service_dl;
import 'package:sarvoday_marine/features/location_module/location_injection_container.dart'
    as location_dl;
import 'package:sarvoday_marine/features/authentication_module/authentication_injection_container.dart'
    as authentication_dl;
import 'package:sarvoday_marine/features/client_module/client_module_injection_container.dart'
    as client_dl;
import 'package:sarvoday_marine/features/calendar_module/calendar_injection_container.dart'
    as calendar_dl;
import 'package:sarvoday_marine/features/employee_module/employee_injection_container.dart'
    as employee_dl;
import 'package:sarvoday_marine/features/splash/splash_screen_injection_container.dart'
    as splash_dl;
import 'package:sarvoday_marine/features/report_module/report_injection_container.dart'
    as report_dl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service_dl.init();
  await employee_dl.init();
  await authentication_dl.init();
  await location_dl.init();
  await client_dl.init();
  await calendar_dl.init();
  await report_dl.init();
  await splash_dl.init();

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
      // routerDelegate: _router.delegate(),
      // routeInformationParser: _router.defaultRouteParser(),
    );
  }
}
