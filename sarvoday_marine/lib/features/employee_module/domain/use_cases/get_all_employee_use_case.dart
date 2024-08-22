import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/employee_module/data/models/employee_model.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';

class GetAllEmployeesUseCase {
  final EmployeeRepository employeeRepository;

  GetAllEmployeesUseCase(this.employeeRepository);

  Future<Either<List<EmployeeModel>, CommonFailure>> call() async {
    return await employeeRepository.getAllEmployees();
  }
}
