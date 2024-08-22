import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/sales_order_state.dart';
import 'package:sarvoday_marine/features/client_module/presentation/cubit/client_cubit.dart';
import 'package:sarvoday_marine/features/employee_module/presentation/cubit/employee_cubit.dart';
import 'package:sarvoday_marine/features/location_module/presentation/cubit/location_cubit.dart';

class SalesOrderCubit extends Cubit<SalesOrderState> {
  final EmployeeCubit _employeeCubit;
  final ClientCubit _clientCubit;
  final LocationCubit _locationCubit;

  SalesOrderCubit(this._employeeCubit, this._clientCubit, this._locationCubit)
      : super(SalesOrderState()) {
    _employeeCubit.stream.listen((employeeState) {
      if (employeeState is EmpStateLoading) {
        emit(state.copyWith(employeesLoading: true));
      } else if (employeeState is EmpStateOnSuccess) {
        emit(state.copyWith(
          employeesLoading: false,
          employees: employeeState.response,
        ));
      } else if (employeeState is EmpStateErrorGeneral) {
        emit(state.copyWith(
          employeesLoading: false,
          employeesError: employeeState.errorMessage,
        ));
      }
    });

    _clientCubit.stream.listen((clientState) {
      if (clientState is CStateLoading) {
        emit(state.copyWith(clientsLoading: true));
      } else if (clientState is CStateOnSuccess) {
        emit(state.copyWith(
          clientsLoading: false,
          clients: clientState.response,
        ));
      } else if (clientState is CStateErrorGeneral) {
        emit(state.copyWith(
          clientsLoading: false,
          clientsError: clientState.errorMessage,
        ));
      }
    });

    _locationCubit.stream.listen((locationState) {
      if (locationState is LocationStateLoading) {
        emit(state.copyWith(locationsLoading: true));
      } else if (locationState is LocationStateOnSuccess) {
        emit(state.copyWith(
          locationsLoading: false,
          locations: locationState.response,
        ));
      } else if (locationState is LocationStateErrorGeneral) {
        emit(state.copyWith(
          locationsLoading: false,
          locationsError: locationState.errorMessage,
        ));
      }
    });

    fetchData();
  }

  Future<void> fetchData() async {
    _employeeCubit.getAllEmployee();
    _clientCubit.getAllClient();
    _locationCubit.getAllLocations();
  }

  void setFieldReadOnly(bool isReadOnly, String fieldName) {
    if (fieldName == 'client') {
      emit(state.copyWith(clientSelected: isReadOnly));
    } else if (fieldName == 'location') {
      emit(state.copyWith(locationSelected: isReadOnly));
    }
  }
}
