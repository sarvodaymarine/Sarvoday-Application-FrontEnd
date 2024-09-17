import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/employee_module/data/data_sources/employee_data_source.dart';
import 'package:sarvoday_marine/features/employee_module/domain/use_cases/add_employee_use_case.dart';

import '../models/employee_model.dart';

class EmployeeDataSourceImpl implements EmployeeDataSource {
  final DioClient dio;

  EmployeeDataSourceImpl(this.dio);

  @override
  Future<Either<bool, String>> addEmployee(EmployeeParam employeeParam) async {
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
        return right(CommonMethods.commonErrorHandler(response));
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<bool, String>> deleteEmployee(String employeeId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}employees/deleteEmployee/$employeeId');
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(CommonMethods.commonErrorHandler(response));
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<List<EmployeeModel>, String>> getAllEmployees() async {
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
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<EmployeeModel, String>> updateEmployee(
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
          return right(CommonMethods.commonErrorHandler(response));
        }
      } else {
        return right('There is no changes Detected');
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<bool, String>> disableEnableEmployee(
      String employeeId, bool isActive) async {
    try {
      Map<String, dynamic> data = {'isActive': isActive};

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}users/enableDisable/$employeeId',
            data: data);
        if (response.statusCode == 200) {
          return left(true);
        } else {
          return right(CommonMethods.commonErrorHandler(response));
        }
      } else {
        return right('There is no changes Detected');
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }
}
