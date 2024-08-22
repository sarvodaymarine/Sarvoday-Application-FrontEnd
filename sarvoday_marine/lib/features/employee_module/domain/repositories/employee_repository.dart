import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';

abstract class EmployeeRepository {
  Future<Either<List<EmployeeModel>, CommonFailure>> getAllEmployees();

  Future<Either<bool, CommonFailure>> addEmployee(EmployeeParam employeeParam);

  Future<Either<bool, CommonFailure>> deleteEmployee(String employeeId);

  Future<Either<bool, CommonFailure>> disableEnableEmployee(
      String employeeId, bool isActive);

  Future<Either<EmployeeModel, CommonFailure>> updateEmployee(
      String employeeId, EmployeeParam employeeParam);
}
