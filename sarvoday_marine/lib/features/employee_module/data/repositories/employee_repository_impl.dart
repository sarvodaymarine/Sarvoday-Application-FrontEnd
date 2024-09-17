import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/employee_module/data/data_sources/employee_data_source.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDataSource employeeDataSource;

  EmployeeRepositoryImpl(this.employeeDataSource);

  @override
  Future<Either<bool, String>> addEmployee(EmployeeParam employeeParam) async {
    return await employeeDataSource.addEmployee(employeeParam);
  }

  @override
  Future<Either<bool, String>> deleteEmployee(String serviceId) async {
    return await employeeDataSource.deleteEmployee(serviceId);
  }

  @override
  Future<Either<List<EmployeeModel>, String>> getAllEmployees() async {
    return await employeeDataSource.getAllEmployees();
  }

  @override
  Future<Either<EmployeeModel, String>> updateEmployee(
      String serviceId, EmployeeParam employeeParam) async {
    return await employeeDataSource.updateEmployee(serviceId, employeeParam);
  }

  @override
  Future<Either<bool, String>> disableEnableEmployee(
      String employeeId, bool isActive) async {
    return await employeeDataSource.disableEnableEmployee(employeeId, isActive);
  }
}
