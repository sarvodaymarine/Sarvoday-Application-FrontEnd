// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;
import 'package:sarvoday_marine/features/authentication_module/presentation/pages/password_change_page.dart'
    as _i4;
import 'package:sarvoday_marine/features/authentication_module/presentation/pages/sign_in_page.dart'
    as _i11;
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart'
    as _i15;
import 'package:sarvoday_marine/features/calendar_module/presentation/pages/add_update_sales_order_page.dart'
    as _i1;
import 'package:sarvoday_marine/features/calendar_module/presentation/pages/calendar_page.dart'
    as _i3;
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart'
    as _i17;
import 'package:sarvoday_marine/features/client_module/presentation/pages/client_add_update_page.dart'
    as _i5;
import 'package:sarvoday_marine/features/client_module/presentation/pages/client_list_page.dart'
    as _i6;
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart'
    as _i18;
import 'package:sarvoday_marine/features/employee_module/presentation/pages/employee_details_Add_update_page.dart'
    as _i7;
import 'package:sarvoday_marine/features/employee_module/presentation/pages/employee_list_page.dart'
    as _i8;
import 'package:sarvoday_marine/features/location_module/presentation/pages/location_list_page.dart'
    as _i9;
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart'
    as _i16;
import 'package:sarvoday_marine/features/service_module/presentation/pages/add_update_service_page.dart'
    as _i2;
import 'package:sarvoday_marine/features/service_module/presentation/pages/services_list_page.dart'
    as _i10;
import 'package:sarvoday_marine/features/splash/presentation/pages/splash_screen.dart'
    as _i12;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    AddUpdateSalesOrderRoute.name: (routeData) {
      final args = routeData.argsAs<AddUpdateSalesOrderRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(
            child: _i1.AddUpdateSalesOrderPage(
          key: args.key,
          isFromEdit: args.isFromEdit,
          isDisabled: args.isDisabled,
          salesOrderModel: args.salesOrderModel,
        )),
      );
    },
    AddUpdateServiceRoute.name: (routeData) {
      final args = routeData.argsAs<AddUpdateServiceRouteArgs>(
          orElse: () => const AddUpdateServiceRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(
            child: _i2.AddUpdateServicePage(
          key: args.key,
          isEdit: args.isEdit,
          serviceModel: args.serviceModel,
        )),
      );
    },
    CalendarRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: const _i3.CalendarPage()),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      final args = routeData.argsAs<ChangePasswordRouteArgs>(
          orElse: () => const ChangePasswordRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: _i4.ChangePasswordPage(key: args.key)),
      );
    },
    ClientAddUpdateRoute.name: (routeData) {
      final args = routeData.argsAs<ClientAddUpdateRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(
            child: _i5.ClientAddUpdatePage(
          key: args.key,
          clientModel: args.clientModel,
          isFromEdit: args.isFromEdit,
        )),
      );
    },
    ClientListRoute.name: (routeData) {
      final args = routeData.argsAs<ClientListRouteArgs>(
          orElse: () => const ClientListRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: _i6.ClientListPage(key: args.key)),
      );
    },
    EmployeeDetailsAddUpdateRoute.name: (routeData) {
      final args = routeData.argsAs<EmployeeDetailsAddUpdateRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(
            child: _i7.EmployeeDetailsAddUpdatePage(
          key: args.key,
          employeeModel: args.employeeModel,
          isFromEdit: args.isFromEdit,
        )),
      );
    },
    EmployeeListRoute.name: (routeData) {
      final args = routeData.argsAs<EmployeeListRouteArgs>(
          orElse: () => const EmployeeListRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: _i8.EmployeeListPage(key: args.key)),
      );
    },
    LocationListRoute.name: (routeData) {
      final args = routeData.argsAs<LocationListRouteArgs>(
          orElse: () => const LocationListRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: _i9.LocationListPage(key: args.key)),
      );
    },
    ServicesListRoute.name: (routeData) {
      final args = routeData.argsAs<ServicesListRouteArgs>(
          orElse: () => const ServicesListRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: _i10.ServicesListPage(key: args.key)),
      );
    },
    SignInRoute.name: (routeData) {
      final args = routeData.argsAs<SignInRouteArgs>(
          orElse: () => const SignInRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WrappedRoute(child: _i11.SignInPage(key: args.key)),
      );
    },
    SplashRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddUpdateSalesOrderPage]
class AddUpdateSalesOrderRoute
    extends _i13.PageRouteInfo<AddUpdateSalesOrderRouteArgs> {
  AddUpdateSalesOrderRoute({
    _i14.Key? key,
    required bool isFromEdit,
    required bool isDisabled,
    _i15.SalesOrderModel? salesOrderModel,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          AddUpdateSalesOrderRoute.name,
          args: AddUpdateSalesOrderRouteArgs(
            key: key,
            isFromEdit: isFromEdit,
            isDisabled: isDisabled,
            salesOrderModel: salesOrderModel,
          ),
          initialChildren: children,
        );

  static const String name = 'AddUpdateSalesOrderRoute';

  static const _i13.PageInfo<AddUpdateSalesOrderRouteArgs> page =
      _i13.PageInfo<AddUpdateSalesOrderRouteArgs>(name);
}

class AddUpdateSalesOrderRouteArgs {
  const AddUpdateSalesOrderRouteArgs({
    this.key,
    required this.isFromEdit,
    required this.isDisabled,
    this.salesOrderModel,
  });

  final _i14.Key? key;

  final bool isFromEdit;

  final bool isDisabled;

  final _i15.SalesOrderModel? salesOrderModel;

  @override
  String toString() {
    return 'AddUpdateSalesOrderRouteArgs{key: $key, isFromEdit: $isFromEdit, isDisabled: $isDisabled, salesOrderModel: $salesOrderModel}';
  }
}

/// generated route for
/// [_i2.AddUpdateServicePage]
class AddUpdateServiceRoute
    extends _i13.PageRouteInfo<AddUpdateServiceRouteArgs> {
  AddUpdateServiceRoute({
    _i14.Key? key,
    bool isEdit = false,
    _i16.ServiceModel? serviceModel,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          AddUpdateServiceRoute.name,
          args: AddUpdateServiceRouteArgs(
            key: key,
            isEdit: isEdit,
            serviceModel: serviceModel,
          ),
          initialChildren: children,
        );

  static const String name = 'AddUpdateServiceRoute';

  static const _i13.PageInfo<AddUpdateServiceRouteArgs> page =
      _i13.PageInfo<AddUpdateServiceRouteArgs>(name);
}

class AddUpdateServiceRouteArgs {
  const AddUpdateServiceRouteArgs({
    this.key,
    this.isEdit = false,
    this.serviceModel,
  });

  final _i14.Key? key;

  final bool isEdit;

  final _i16.ServiceModel? serviceModel;

  @override
  String toString() {
    return 'AddUpdateServiceRouteArgs{key: $key, isEdit: $isEdit, serviceModel: $serviceModel}';
  }
}

/// generated route for
/// [_i3.CalendarPage]
class CalendarRoute extends _i13.PageRouteInfo<void> {
  const CalendarRoute({List<_i13.PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ChangePasswordPage]
class ChangePasswordRoute extends _i13.PageRouteInfo<ChangePasswordRouteArgs> {
  ChangePasswordRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ChangePasswordRoute.name,
          args: ChangePasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i13.PageInfo<ChangePasswordRouteArgs> page =
      _i13.PageInfo<ChangePasswordRouteArgs>(name);
}

class ChangePasswordRouteArgs {
  const ChangePasswordRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'ChangePasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ClientAddUpdatePage]
class ClientAddUpdateRoute
    extends _i13.PageRouteInfo<ClientAddUpdateRouteArgs> {
  ClientAddUpdateRoute({
    _i14.Key? key,
    _i17.ClientModel? clientModel,
    required bool isFromEdit,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ClientAddUpdateRoute.name,
          args: ClientAddUpdateRouteArgs(
            key: key,
            clientModel: clientModel,
            isFromEdit: isFromEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientAddUpdateRoute';

  static const _i13.PageInfo<ClientAddUpdateRouteArgs> page =
      _i13.PageInfo<ClientAddUpdateRouteArgs>(name);
}

class ClientAddUpdateRouteArgs {
  const ClientAddUpdateRouteArgs({
    this.key,
    this.clientModel,
    required this.isFromEdit,
  });

  final _i14.Key? key;

  final _i17.ClientModel? clientModel;

  final bool isFromEdit;

  @override
  String toString() {
    return 'ClientAddUpdateRouteArgs{key: $key, clientModel: $clientModel, isFromEdit: $isFromEdit}';
  }
}

/// generated route for
/// [_i6.ClientListPage]
class ClientListRoute extends _i13.PageRouteInfo<ClientListRouteArgs> {
  ClientListRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ClientListRoute.name,
          args: ClientListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ClientListRoute';

  static const _i13.PageInfo<ClientListRouteArgs> page =
      _i13.PageInfo<ClientListRouteArgs>(name);
}

class ClientListRouteArgs {
  const ClientListRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'ClientListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.EmployeeDetailsAddUpdatePage]
class EmployeeDetailsAddUpdateRoute
    extends _i13.PageRouteInfo<EmployeeDetailsAddUpdateRouteArgs> {
  EmployeeDetailsAddUpdateRoute({
    _i14.Key? key,
    _i18.EmployeeModel? employeeModel,
    required bool isFromEdit,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          EmployeeDetailsAddUpdateRoute.name,
          args: EmployeeDetailsAddUpdateRouteArgs(
            key: key,
            employeeModel: employeeModel,
            isFromEdit: isFromEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'EmployeeDetailsAddUpdateRoute';

  static const _i13.PageInfo<EmployeeDetailsAddUpdateRouteArgs> page =
      _i13.PageInfo<EmployeeDetailsAddUpdateRouteArgs>(name);
}

class EmployeeDetailsAddUpdateRouteArgs {
  const EmployeeDetailsAddUpdateRouteArgs({
    this.key,
    this.employeeModel,
    required this.isFromEdit,
  });

  final _i14.Key? key;

  final _i18.EmployeeModel? employeeModel;

  final bool isFromEdit;

  @override
  String toString() {
    return 'EmployeeDetailsAddUpdateRouteArgs{key: $key, employeeModel: $employeeModel, isFromEdit: $isFromEdit}';
  }
}

/// generated route for
/// [_i8.EmployeeListPage]
class EmployeeListRoute extends _i13.PageRouteInfo<EmployeeListRouteArgs> {
  EmployeeListRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          EmployeeListRoute.name,
          args: EmployeeListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EmployeeListRoute';

  static const _i13.PageInfo<EmployeeListRouteArgs> page =
      _i13.PageInfo<EmployeeListRouteArgs>(name);
}

class EmployeeListRouteArgs {
  const EmployeeListRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'EmployeeListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.LocationListPage]
class LocationListRoute extends _i13.PageRouteInfo<LocationListRouteArgs> {
  LocationListRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          LocationListRoute.name,
          args: LocationListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LocationListRoute';

  static const _i13.PageInfo<LocationListRouteArgs> page =
      _i13.PageInfo<LocationListRouteArgs>(name);
}

class LocationListRouteArgs {
  const LocationListRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'LocationListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i10.ServicesListPage]
class ServicesListRoute extends _i13.PageRouteInfo<ServicesListRouteArgs> {
  ServicesListRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ServicesListRoute.name,
          args: ServicesListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServicesListRoute';

  static const _i13.PageInfo<ServicesListRouteArgs> page =
      _i13.PageInfo<ServicesListRouteArgs>(name);
}

class ServicesListRouteArgs {
  const ServicesListRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'ServicesListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i11.SignInPage]
class SignInRoute extends _i13.PageRouteInfo<SignInRouteArgs> {
  SignInRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          SignInRoute.name,
          args: SignInRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i13.PageInfo<SignInRouteArgs> page =
      _i13.PageInfo<SignInRouteArgs>(name);
}

class SignInRouteArgs {
  const SignInRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'SignInRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.SplashScreen]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}
