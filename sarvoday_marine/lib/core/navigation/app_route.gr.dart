// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i17;
import 'package:sarvoday_marine/features/authentication_module/presentation/pages/password_change_page.dart'
    as _i4;
import 'package:sarvoday_marine/features/authentication_module/presentation/pages/sign_in_page.dart'
    as _i13;
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart'
    as _i18;
import 'package:sarvoday_marine/features/calendar_module/presentation/pages/add_update_sales_order_page.dart'
    as _i1;
import 'package:sarvoday_marine/features/calendar_module/presentation/pages/calendar_page.dart'
    as _i3;
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart'
    as _i20;
import 'package:sarvoday_marine/features/client_module/presentation/pages/client_add_update_page.dart'
    as _i5;
import 'package:sarvoday_marine/features/client_module/presentation/pages/client_list_page.dart'
    as _i6;
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart'
    as _i21;
import 'package:sarvoday_marine/features/employee_module/presentation/pages/employee_details_Add_update_page.dart'
    as _i7;
import 'package:sarvoday_marine/features/employee_module/presentation/pages/employee_list_page.dart'
    as _i8;
import 'package:sarvoday_marine/features/location_module/presentation/pages/location_list_page.dart'
    as _i9;
import 'package:sarvoday_marine/features/report_module/presentation/pages/report_page.dart'
    as _i10;
import 'package:sarvoday_marine/features/report_module/presentation/pages/service_report_page.dart'
    as _i11;
import 'package:sarvoday_marine/features/report_module/presentation/pages/summury_page.dart'
    as _i15;
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart'
    as _i19;
import 'package:sarvoday_marine/features/service_module/presentation/pages/add_update_service_page.dart'
    as _i2;
import 'package:sarvoday_marine/features/service_module/presentation/pages/services_list_page.dart'
    as _i12;
import 'package:sarvoday_marine/features/splash/presentation/pages/splash_screen.dart'
    as _i14;

/// generated route for
/// [_i1.AddUpdateSalesOrderPage]
class AddUpdateSalesOrderRoute
    extends _i16.PageRouteInfo<AddUpdateSalesOrderRouteArgs> {
  AddUpdateSalesOrderRoute({
    _i17.Key? key,
    required bool isFromEdit,
    required bool isDisabled,
    required bool isClientOrSuperAdmin,
    _i18.SalesOrderModel? salesOrderModel,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          AddUpdateSalesOrderRoute.name,
          args: AddUpdateSalesOrderRouteArgs(
            key: key,
            isFromEdit: isFromEdit,
            isDisabled: isDisabled,
            isClientOrSuperAdmin: isClientOrSuperAdmin,
            salesOrderModel: salesOrderModel,
          ),
          initialChildren: children,
        );

  static const String name = 'AddUpdateSalesOrderRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddUpdateSalesOrderRouteArgs>();
      return _i16.WrappedRoute(
          child: _i1.AddUpdateSalesOrderPage(
        key: args.key,
        isFromEdit: args.isFromEdit,
        isDisabled: args.isDisabled,
        isClientOrSuperAdmin: args.isClientOrSuperAdmin,
        salesOrderModel: args.salesOrderModel,
      ));
    },
  );
}

class AddUpdateSalesOrderRouteArgs {
  const AddUpdateSalesOrderRouteArgs({
    this.key,
    required this.isFromEdit,
    required this.isDisabled,
    required this.isClientOrSuperAdmin,
    this.salesOrderModel,
  });

  final _i17.Key? key;

  final bool isFromEdit;

  final bool isDisabled;

  final bool isClientOrSuperAdmin;

  final _i18.SalesOrderModel? salesOrderModel;

  @override
  String toString() {
    return 'AddUpdateSalesOrderRouteArgs{key: $key, isFromEdit: $isFromEdit, isDisabled: $isDisabled, isClientOrSuperAdmin: $isClientOrSuperAdmin, salesOrderModel: $salesOrderModel}';
  }
}

/// generated route for
/// [_i2.AddUpdateServicePage]
class AddUpdateServiceRoute
    extends _i16.PageRouteInfo<AddUpdateServiceRouteArgs> {
  AddUpdateServiceRoute({
    _i17.Key? key,
    bool isEdit = false,
    _i19.ServiceModel? serviceModel,
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddUpdateServiceRouteArgs>(
          orElse: () => const AddUpdateServiceRouteArgs());
      return _i16.WrappedRoute(
          child: _i2.AddUpdateServicePage(
        key: args.key,
        isEdit: args.isEdit,
        serviceModel: args.serviceModel,
      ));
    },
  );
}

class AddUpdateServiceRouteArgs {
  const AddUpdateServiceRouteArgs({
    this.key,
    this.isEdit = false,
    this.serviceModel,
  });

  final _i17.Key? key;

  final bool isEdit;

  final _i19.ServiceModel? serviceModel;

  @override
  String toString() {
    return 'AddUpdateServiceRouteArgs{key: $key, isEdit: $isEdit, serviceModel: $serviceModel}';
  }
}

/// generated route for
/// [_i3.CalendarPage]
class CalendarRoute extends _i16.PageRouteInfo<void> {
  const CalendarRoute({List<_i16.PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return _i16.WrappedRoute(child: const _i3.CalendarPage());
    },
  );
}

/// generated route for
/// [_i4.ChangePasswordPage]
class ChangePasswordRoute extends _i16.PageRouteInfo<ChangePasswordRouteArgs> {
  ChangePasswordRoute({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ChangePasswordRoute.name,
          args: ChangePasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangePasswordRouteArgs>(
          orElse: () => const ChangePasswordRouteArgs());
      return _i16.WrappedRoute(child: _i4.ChangePasswordPage(key: args.key));
    },
  );
}

class ChangePasswordRouteArgs {
  const ChangePasswordRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'ChangePasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ClientAddUpdatePage]
class ClientAddUpdateRoute
    extends _i16.PageRouteInfo<ClientAddUpdateRouteArgs> {
  ClientAddUpdateRoute({
    _i17.Key? key,
    _i20.ClientModel? clientModel,
    required bool isFromEdit,
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientAddUpdateRouteArgs>();
      return _i16.WrappedRoute(
          child: _i5.ClientAddUpdatePage(
        key: args.key,
        clientModel: args.clientModel,
        isFromEdit: args.isFromEdit,
      ));
    },
  );
}

class ClientAddUpdateRouteArgs {
  const ClientAddUpdateRouteArgs({
    this.key,
    this.clientModel,
    required this.isFromEdit,
  });

  final _i17.Key? key;

  final _i20.ClientModel? clientModel;

  final bool isFromEdit;

  @override
  String toString() {
    return 'ClientAddUpdateRouteArgs{key: $key, clientModel: $clientModel, isFromEdit: $isFromEdit}';
  }
}

/// generated route for
/// [_i6.ClientListPage]
class ClientListRoute extends _i16.PageRouteInfo<ClientListRouteArgs> {
  ClientListRoute({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ClientListRoute.name,
          args: ClientListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ClientListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientListRouteArgs>(
          orElse: () => const ClientListRouteArgs());
      return _i16.WrappedRoute(child: _i6.ClientListPage(key: args.key));
    },
  );
}

class ClientListRouteArgs {
  const ClientListRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'ClientListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.EmployeeDetailsAddUpdatePage]
class EmployeeDetailsAddUpdateRoute
    extends _i16.PageRouteInfo<EmployeeDetailsAddUpdateRouteArgs> {
  EmployeeDetailsAddUpdateRoute({
    _i17.Key? key,
    _i21.EmployeeModel? employeeModel,
    required bool isFromEdit,
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmployeeDetailsAddUpdateRouteArgs>();
      return _i16.WrappedRoute(
          child: _i7.EmployeeDetailsAddUpdatePage(
        key: args.key,
        employeeModel: args.employeeModel,
        isFromEdit: args.isFromEdit,
      ));
    },
  );
}

class EmployeeDetailsAddUpdateRouteArgs {
  const EmployeeDetailsAddUpdateRouteArgs({
    this.key,
    this.employeeModel,
    required this.isFromEdit,
  });

  final _i17.Key? key;

  final _i21.EmployeeModel? employeeModel;

  final bool isFromEdit;

  @override
  String toString() {
    return 'EmployeeDetailsAddUpdateRouteArgs{key: $key, employeeModel: $employeeModel, isFromEdit: $isFromEdit}';
  }
}

/// generated route for
/// [_i8.EmployeeListPage]
class EmployeeListRoute extends _i16.PageRouteInfo<EmployeeListRouteArgs> {
  EmployeeListRoute({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          EmployeeListRoute.name,
          args: EmployeeListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EmployeeListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmployeeListRouteArgs>(
          orElse: () => const EmployeeListRouteArgs());
      return _i16.WrappedRoute(child: _i8.EmployeeListPage(key: args.key));
    },
  );
}

class EmployeeListRouteArgs {
  const EmployeeListRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'EmployeeListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.LocationListPage]
class LocationListRoute extends _i16.PageRouteInfo<LocationListRouteArgs> {
  LocationListRoute({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          LocationListRoute.name,
          args: LocationListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LocationListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocationListRouteArgs>(
          orElse: () => const LocationListRouteArgs());
      return _i16.WrappedRoute(child: _i9.LocationListPage(key: args.key));
    },
  );
}

class LocationListRouteArgs {
  const LocationListRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'LocationListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i10.ReportPage]
class ReportRoute extends _i16.PageRouteInfo<ReportRouteArgs> {
  ReportRoute({
    _i17.Key? key,
    required String orderId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ReportRoute.name,
          args: ReportRouteArgs(
            key: key,
            orderId: orderId,
          ),
          initialChildren: children,
        );

  static const String name = 'ReportRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReportRouteArgs>();
      return _i16.WrappedRoute(
          child: _i10.ReportPage(
        key: args.key,
        orderId: args.orderId,
      ));
    },
  );
}

class ReportRouteArgs {
  const ReportRouteArgs({
    this.key,
    required this.orderId,
  });

  final _i17.Key? key;

  final String orderId;

  @override
  String toString() {
    return 'ReportRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i11.ServiceDetailPage]
class ServiceDetailRoute extends _i16.PageRouteInfo<ServiceDetailRouteArgs> {
  ServiceDetailRoute({
    _i17.Key? key,
    required String serviceId,
    required String orderId,
    required String reportId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ServiceDetailRoute.name,
          args: ServiceDetailRouteArgs(
            key: key,
            serviceId: serviceId,
            orderId: orderId,
            reportId: reportId,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceDetailRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServiceDetailRouteArgs>();
      return _i16.WrappedRoute(
          child: _i11.ServiceDetailPage(
        key: args.key,
        serviceId: args.serviceId,
        orderId: args.orderId,
        reportId: args.reportId,
      ));
    },
  );
}

class ServiceDetailRouteArgs {
  const ServiceDetailRouteArgs({
    this.key,
    required this.serviceId,
    required this.orderId,
    required this.reportId,
  });

  final _i17.Key? key;

  final String serviceId;

  final String orderId;

  final String reportId;

  @override
  String toString() {
    return 'ServiceDetailRouteArgs{key: $key, serviceId: $serviceId, orderId: $orderId, reportId: $reportId}';
  }
}

/// generated route for
/// [_i12.ServicesListPage]
class ServicesListRoute extends _i16.PageRouteInfo<ServicesListRouteArgs> {
  ServicesListRoute({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ServicesListRoute.name,
          args: ServicesListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ServicesListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServicesListRouteArgs>(
          orElse: () => const ServicesListRouteArgs());
      return _i16.WrappedRoute(child: _i12.ServicesListPage(key: args.key));
    },
  );
}

class ServicesListRouteArgs {
  const ServicesListRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'ServicesListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i13.SignInPage]
class SignInRoute extends _i16.PageRouteInfo<SignInRouteArgs> {
  SignInRoute({
    _i17.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          SignInRoute.name,
          args: SignInRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SignInRouteArgs>(orElse: () => const SignInRouteArgs());
      return _i16.WrappedRoute(child: _i13.SignInPage(key: args.key));
    },
  );
}

class SignInRouteArgs {
  const SignInRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'SignInRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i14.SplashScreen]
class SplashRoute extends _i16.PageRouteInfo<void> {
  const SplashRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return _i16.WrappedRoute(child: const _i14.SplashScreen());
    },
  );
}

/// generated route for
/// [_i15.SummaryPage]
class SummaryRoute extends _i16.PageRouteInfo<SummaryRouteArgs> {
  SummaryRoute({
    _i17.Key? key,
    required _i18.SalesOrderModel? salesOrderModel,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          SummaryRoute.name,
          args: SummaryRouteArgs(
            key: key,
            salesOrderModel: salesOrderModel,
          ),
          initialChildren: children,
        );

  static const String name = 'SummaryRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SummaryRouteArgs>();
      return _i15.SummaryPage(
        key: args.key,
        salesOrderModel: args.salesOrderModel,
      );
    },
  );
}

class SummaryRouteArgs {
  const SummaryRouteArgs({
    this.key,
    required this.salesOrderModel,
  });

  final _i17.Key? key;

  final _i18.SalesOrderModel? salesOrderModel;

  @override
  String toString() {
    return 'SummaryRouteArgs{key: $key, salesOrderModel: $salesOrderModel}';
  }
}
