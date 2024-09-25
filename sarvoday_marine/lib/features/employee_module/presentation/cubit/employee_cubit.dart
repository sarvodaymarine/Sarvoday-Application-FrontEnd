import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/use_cases/reset_password_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/delete_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/enable_disable_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/get_all_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/update_employee_use_case.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit(
      this.getAllEmployeesUseCase,
      this.addEmployeeUseCase,
      this.deleteEmployeeUseCase,
      this.resetPasswordUseCase,
      this.updateEmployeeUseCase,
      this.enableDisableEmployeeUseCase)
      : super(EmployeeInitial());

  final GetAllEmployeesUseCase getAllEmployeesUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final EnableDisableEmployeeUseCase enableDisableEmployeeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  getAllEmployee({bool needFetchData = false}) async {
    if (needFetchData) {
      emit(EmpStateLoading());
    }
    var res = await getAllEmployeesUseCase.call();
    res.fold((employee) {
      emit(EmpStateOnSuccess(employee));
    }, (error) {
      emit(EmpStateErrorGeneral(error.toString()));
    });
  }

  resetEmployeePassword(String userId) async {
    emit(EmpStateNoData());
    var res = await resetPasswordUseCase.call(userId);
    res.fold((client) {
      emit(EmpStateOnCrudSuccess(
          "Reset password successfully sent to the Employee!"));
    }, (error) {
      emit(EmpStateErrorGeneral(error.toString()));
    });
  }

  addEmployee(String firstName, String lastName, String email,
      String countryCode, String mobile, String userRole) async {
    emit(EmpStateNoData());
    var res = await addEmployeeUseCase.call(EmployeeParam(
        firstName, lastName, email, mobile, countryCode, userRole));
    res.fold((employee) {
      emit(EmpStateOnCrudSuccess("Employee Added SuccessFully"));
      getAllEmployee(needFetchData: true);
    }, (error) {
      emit(EmpStateErrorGeneral(error.toString()));
    });
  }

  deleteEmployee(String employeeId) async {
    emit(EmpStateNoData());
    var res = await deleteEmployeeUseCase.call(employeeId);
    res.fold((employee) {
      emit(EmpStateOnCrudSuccess("Employee deleted SuccessFully!"));
      getAllEmployee(needFetchData: true);
    }, (error) {
      emit(EmpStateErrorGeneral(error.toString()));
    });
  }

  disableEmployee(String employeeId, bool isActive) async {
    emit(EmpStateNoData());
    var res = await enableDisableEmployeeUseCase.call(employeeId, isActive);
    res.fold((employee) {
      emit(EmpStateOnCrudSuccess(isActive
          ? "Employee is authentication activated!"
          : "Employee disabled!"));
      getAllEmployee(needFetchData: true);
    }, (error) {
      emit(EmpStateErrorGeneral(error.toString()));
    });
  }

  updateEmployee(String employeeId, String firstName, String lastName,
      String mobile, String email, String countryCode, String userRole) async {
    emit(EmpStateNoData());
    if (employeeId.isNotEmpty) {
      if (firstName.isEmpty &&
          lastName.isEmpty &&
          mobile.isEmpty &&
          countryCode.isEmpty &&
          userRole.isNotEmpty &&
          email.isEmpty) {
        emit(EmpStateErrorGeneral(
            'Employee data cannot be empty. Please provide the necessary information.'));
      } else {
        var res = await updateEmployeeUseCase.call(
            employeeId,
            EmployeeParam(
                firstName, lastName, email, mobile, countryCode, userRole));
        res.fold((employee) {
          emit(EmpStateOnCrudSuccess('Employee updated Successfully!'));
          getAllEmployee(needFetchData: true);
        }, (error) {
          emit(EmpStateErrorGeneral(error.toString()));
        });
      }
    } else {
      emit(EmpStateErrorGeneral("Something went to wrong!"));
    }
  }
}
