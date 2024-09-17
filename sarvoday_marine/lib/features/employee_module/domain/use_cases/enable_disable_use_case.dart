import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';

class EnableDisableEmployeeUseCase {
  final EmployeeRepository employeeRepository;

  EnableDisableEmployeeUseCase(this.employeeRepository);

  Future<Either<bool, String>> call(String employeeId, bool isActive) async {
    return await employeeRepository.disableEnableEmployee(employeeId, isActive);
  }
}
