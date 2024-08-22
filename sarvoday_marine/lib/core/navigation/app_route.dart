import 'package:auto_route/auto_route.dart';
import 'package:sarvoday_marine/features/service_module/presentation/pages/add_update_service_page.dart';
import 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page),
    AutoRoute(page: SignInRoute.page, initial: true),
    AutoRoute(page: ClientAddUpdateRoute.page),
    AutoRoute(page: ClientListRoute.page),
    AutoRoute(page: EmployeeDetailsAddUpdateRoute.page),
    AutoRoute(page: EmployeeListRoute.page),
    AutoRoute(page: LocationListRoute.page),
    AutoRoute(page: AddUpdateSalesOrderRoute.page),
    AutoRoute(page: AddUpdateServiceRoute.page),
    AutoRoute(page: CalendarRoute.page),
    AutoRoute(page: ServicesListRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
  ];
}
