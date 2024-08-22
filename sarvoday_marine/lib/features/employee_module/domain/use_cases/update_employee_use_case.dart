import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepository employeeRepository;

  UpdateEmployeeUseCase(this.employeeRepository);

  Future<Either<EmployeeModel, CommonFailure>> call(
      String employeeId, EmployeeParam employeeParam) async {
    return await employeeRepository.updateEmployee(employeeId, employeeParam);
  }
}
