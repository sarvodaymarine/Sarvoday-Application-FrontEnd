import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/employee_module/data/data_sources/employee_data_source.dart';
import 'package:sarvoday_marine/features/employee_module/data/data_sources/employee_data_source_impl.dart';
import 'package:sarvoday_marine/features/employee_module/data/repositories/employee_repository_impl.dart';
import 'package:sarvoday_marine/features/employee_module/domain/repositories/employee_repository.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/delete_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/enable_disable_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/get_all_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/update_employee_use_case.dart';
import 'package:sarvoday_marine/features/employee_module/presentation/cubit/employee_cubit.dart';

GetIt employeeSl = GetIt.instance;

Future<void> init() async {
  employeeSl.registerFactory(() => EmployeeCubit(
      employeeSl(), employeeSl(), employeeSl(), employeeSl(), employeeSl()));

  employeeSl.registerLazySingleton(() => GetAllEmployeesUseCase(employeeSl()));
  employeeSl.registerLazySingleton(() => AddEmployeeUseCase(employeeSl()));
  employeeSl.registerLazySingleton(() => DeleteEmployeeUseCase(employeeSl()));
  employeeSl.registerLazySingleton(() => UpdateEmployeeUseCase(employeeSl()));
  employeeSl
      .registerLazySingleton(() => EnableDisableEmployeeUseCase(employeeSl()));
  employeeSl.registerLazySingleton<EmployeeRepository>(
      () => EmployeeRepositoryImpl(employeeSl()));

  employeeSl.registerFactory<EmployeeDataSource>(
      () => EmployeeDataSourceImpl(employeeSl()));
}
