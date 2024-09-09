import 'package:auto_route/auto_route.dart';
import 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: ClientAddUpdateRoute.page),
    AutoRoute(page: ClientListRoute.page),
    AutoRoute(page: EmployeeDetailsAddUpdateRoute.page),
    AutoRoute(page: EmployeeListRoute.page),
    AutoRoute(page: LocationListRoute.page),
    AutoRoute(page: AddUpdateSalesOrderRoute.page),
    AutoRoute(page: AddUpdateServiceRoute.page),
    AutoRoute(page: ReportRoute.page),
    AutoRoute(page: ServiceDetailRoute.page),
    AutoRoute(page: CalendarRoute.page),
    AutoRoute(page: ServicesListRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
  ];
}
