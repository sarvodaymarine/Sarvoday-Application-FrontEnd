import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepository employeeRepository;

  DeleteEmployeeUseCase(this.employeeRepository);

  Future<Either<bool, String>> call(String employeeId) async {
    return await employeeRepository.deleteEmployee(employeeId);
  }
}
