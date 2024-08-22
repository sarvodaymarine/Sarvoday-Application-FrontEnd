import 'package:equatable/equatable.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';

class SalesOrderState extends Equatable {
  final bool clientSelected;
  final bool locationSelected;
  final bool employeesLoading;
  final bool clientsLoading;
  final bool locationsLoading;
  final String? employeesError;
  final String? clientsError;
  final String? locationsError;
  final List<EmployeeModel>? employees;
  final List<ClientModel>? clients;
  final List<LocationModel>? locations;

  SalesOrderState({
    this.clientSelected = false,
    this.locationSelected = false,
    this.employeesLoading = false,
    this.clientsLoading = false,
    this.locationsLoading = false,
    this.employeesError,
    this.clientsError,
    this.locationsError,
    this.employees,
    this.clients,
    this.locations,
  });

  SalesOrderState copyWith(
      {final bool? clientSelected,
      final bool? locationSelected,
      final bool? employeesLoading,
      final bool? clientsLoading,
      final bool? locationsLoading,
      final String? employeesError,
      final String? clientsError,
      final String? locationsError,
      final List<EmployeeModel>? employees,
      final List<ClientModel>? clients,
      final List<LocationModel>? locations}) {
    return SalesOrderState(
      clientSelected: clientSelected ?? this.clientSelected,
      locationSelected: locationSelected ?? this.locationSelected,
      employeesLoading: employeesLoading ?? this.employeesLoading,
      clientsLoading: clientsLoading ?? this.clientsLoading,
      locationsLoading: locationsLoading ?? this.locationsLoading,
      employeesError: employeesError ?? this.employeesError,
      clientsError: clientsError ?? this.clientsError,
      locationsError: locationsError ?? this.locationsError,
      employees: employees ?? this.employees,
      clients: clients ?? this.clients,
      locations: locations ?? this.locations,
    );
  }

  @override
  List<Object?> get props => [
        clientSelected,
        locationSelected,
        employeesLoading,
        clientsLoading,
        locationsLoading,
        employeesError,
        clientsError,
        locationsError,
        employees ?? [],
        clients ?? [],
        locations ?? [],
      ];
}
