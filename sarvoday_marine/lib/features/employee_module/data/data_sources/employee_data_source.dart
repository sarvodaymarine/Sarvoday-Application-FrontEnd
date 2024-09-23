import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';

abstract class EmployeeDataSource {
  Future<Either<List<EmployeeModel>, String>> getAllEmployees();

  Future<Either<bool, String>> addEmployee(EmployeeParam employeeParam);

  Future<Either<bool, String>> deleteEmployee(String clientId);

  Future<Either<bool, String>> disableEnableEmployee(
      String clientId, bool isActive);

  Future<Either<EmployeeModel, String>> updateEmployee(
      String employeeId, EmployeeParam employeeParam);
}
