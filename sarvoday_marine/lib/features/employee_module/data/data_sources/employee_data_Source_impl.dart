import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/employee_module/data/data_sources/employee_data_source.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';

import '../models/employee_model.dart';

class EmployeeDataSourceImpl implements EmployeeDataSource {
  final Dio dio;

  EmployeeDataSourceImpl(this.dio);

  @override
  Future<Either<bool, CommonFailure>> addEmployee(
      EmployeeParam employeeParam) async {
    try {
      Map<String, dynamic> data = {
        'firstName': employeeParam.firstName,
        'lastName': employeeParam.lastName,
        'mobile': employeeParam.mobile,
        'countryCode': employeeParam.countryCode,
        'email': employeeParam.email,
        'userRole': employeeParam.userRole
      };
      final response = await dio.post(
          '${StringConst.backEndBaseURL}employees/addEmployee',
          data: data);
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(ErrorFailure(response.statusMessage.toString()));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<bool, CommonFailure>> deleteEmployee(String employeeId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}employees/deleteEmployee/$employeeId');
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(ErrorFailure(response.statusMessage.toString()));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<List<EmployeeModel>, CommonFailure>> getAllEmployees() async {
    try {
      final response = await dio
          .get('${StringConst.backEndBaseURL}employees/getAllEmployeeDetails');
      if (response.statusCode == 200) {
        final List<EmployeeModel> employees = [];
        final jsonList = response.data;
        for (var item in jsonList) {
          employees.add(EmployeeModel.fromJson(item));
        }
        return left(employees);
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(
          (ErrorFailure(CommonMethods.commonValidation(error.toString()))));
    }
  }

  @override
  Future<Either<EmployeeModel, CommonFailure>> updateEmployee(
      String employeeId, EmployeeParam employeeParam) async {
    try {
      Map<String, dynamic> data = {};
      if (employeeParam.firstName != null &&
          employeeParam.firstName!.isNotEmpty) {
        data['firstName'] = employeeParam.firstName ?? "";
      }
      if (employeeParam.lastName != null &&
          employeeParam.lastName!.isNotEmpty) {
        data['lastName'] = employeeParam.lastName ?? "";
      }
      if (employeeParam.mobile != null && employeeParam.mobile!.isNotEmpty) {
        data['mobile'] = employeeParam.mobile ?? "";
      }

      if (employeeParam.countryCode != null &&
          employeeParam.countryCode!.isNotEmpty) {
        data['countryCode'] = employeeParam.countryCode ?? "";
      }

      if (employeeParam.email != null && employeeParam.email!.isNotEmpty) {
        data['email'] = employeeParam.email ?? "";
      }

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}employees/updateEmployee/$employeeId',
            data: data);
        if (response.statusCode == 200) {
          final EmployeeModel employee = EmployeeModel.fromJson(response.data);
          return left(employee);
        } else {
          return right(ErrorFailure(CommonMethods.commonValidation(
              response.statusMessage.toString())));
        }
      } else {
        return right(ErrorFailure('There is no changes Detected'));
      }
    } catch (error) {
      return right(
          CommonMethods.commonValidation(ErrorFailure(error.toString())));
    }
  }

  @override
  Future<Either<bool, CommonFailure>> disableEnableEmployee(
      String employeeId, bool isActive) async {
    try {
      Map<String, dynamic> data = {'isActive': isActive};

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}employees/updateEmployee/$employeeId',
            data: data);
        if (response.statusCode == 200) {
          return left(true);
        } else {
          return right(ErrorFailure(response.statusMessage.toString()));
        }
      } else {
        return right(ErrorFailure('There is no changes Detected'));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }
}
