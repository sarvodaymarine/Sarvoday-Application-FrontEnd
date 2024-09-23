import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';

class AddEmployeeUseCase {
  final EmployeeRepository employeeRepository;

  AddEmployeeUseCase(this.employeeRepository);

  Future<Either<bool, String>> call(EmployeeParam employeeParam) async {
    return await employeeRepository.addEmployee(employeeParam);
  }
}

class EmployeeParam {
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? countryCode;
  String? userRole;

  EmployeeParam(this.firstName, this.lastName, this.email, this.mobile,
      this.countryCode, this.userRole);
}
