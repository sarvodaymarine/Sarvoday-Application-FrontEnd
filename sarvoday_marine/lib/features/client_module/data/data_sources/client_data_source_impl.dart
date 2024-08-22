import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/client_module/data/data_sources/client_data_source.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';

class ClientDataSourceImpl implements ClientDataSource {
  final Dio dio;

  ClientDataSourceImpl(this.dio);

  @override
  Future<Either<bool, CommonFailure>> addClient(ClientParam clientParam) async {
    try {
      Map<String, dynamic> data = {
        'firstName': clientParam.firstName,
        'lastName': clientParam.lastName,
        'clientAddress': clientParam.clientAddress,
        'mobile': clientParam.mobile,
        'countryCode': clientParam.countryCode,
        'email': clientParam.email,
        'services': clientParam.services
      };
      final response = await dio
          .post('${StringConst.backEndBaseURL}clients/addClient', data: data);
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
  Future<Either<bool, CommonFailure>> deleteClient(String clientId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}clients/deleteClient/$clientId');
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
  Future<Either<List<ClientModel>, CommonFailure>> getAllClients() async {
    try {
      final response = await dio
          .get('${StringConst.backEndBaseURL}clients/getAllClientDetails');
      if (response.statusCode == 200) {
        final List<ClientModel> clients = [];
        final jsonList = response.data;
        for (var item in jsonList) {
          clients.add(ClientModel.fromJson(item));
        }
        return left(clients);
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(
          (ErrorFailure(CommonMethods.commonValidation(error.toString()))));
    }
  }

  @override
  Future<Either<ClientModel, CommonFailure>> updateClient(
      String clientId, ClientParam clientParam) async {
    try {
      Map<String, dynamic> data = {};
      if (clientParam.firstName != null && clientParam.firstName!.isNotEmpty) {
        data['firstName'] = clientParam.firstName ?? "";
      }
      if (clientParam.lastName != null && clientParam.lastName!.isNotEmpty) {
        data['lastName'] = clientParam.lastName ?? "";
      }
      if (clientParam.clientAddress != null &&
          clientParam.clientAddress!.isNotEmpty) {
        data['clientAddress'] = clientParam.clientAddress ?? "";
      }
      if (clientParam.mobile != null && clientParam.mobile!.isNotEmpty) {
        data['mobile'] = clientParam.mobile ?? "";
      }

      if (clientParam.countryCode != null &&
          clientParam.countryCode!.isNotEmpty) {
        data['countryCode'] = clientParam.countryCode ?? "";
      }

      if (clientParam.email != null && clientParam.email!.isNotEmpty) {
        data['email'] = clientParam.email ?? "";
      }
      if (clientParam.services != null && clientParam.services!.isNotEmpty) {
        data['services'] = clientParam.services;
      }

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}clients/updateClient/$clientId',
            data: data);
        if (response.statusCode == 200) {
          final ClientModel client = ClientModel.fromJson(response.data);
          return left(client);
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
  Future<Either<bool, CommonFailure>> disableEnableClient(
      String clientId, bool isActive) async {
    try {
      Map<String, dynamic> data = {'isActive': isActive};

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}clients/updateClient/$clientId',
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
