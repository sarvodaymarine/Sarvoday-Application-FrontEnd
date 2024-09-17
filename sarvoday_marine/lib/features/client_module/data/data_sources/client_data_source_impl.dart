import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/client_module/data/data_sources/client_data_source.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';

class ClientDataSourceImpl implements ClientDataSource {
  final DioClient dio;

  ClientDataSourceImpl(this.dio);

  @override
  Future<Either<bool, String>> addClient(ClientParam clientParam) async {
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
        return right(response.statusMessage.toString());
      }
    } catch (error) {
      return right(error.toString());
    }
  }

  @override
  Future<Either<bool, String>> deleteClient(String clientId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}clients/deleteClient/$clientId');
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(response.statusMessage.toString());
      }
    } catch (error) {
      return right(error.toString());
    }
  }

  @override
  Future<Either<List<ClientModel>, String>> getAllClients() async {
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
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<ClientModel, String>> updateClient(
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
          return right(
              CommonMethods.commonErrorHandler(response.statusMessage));
        }
      } else {
        return right('There is no changes Detected');
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<bool, String>> disableEnableClient(
      String clientId, bool isActive) async {
    try {
      Map<String, dynamic> data = {'isActive': isActive};

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}/users/enableDisable/$clientId',
            data: data);
        if (response.statusCode == 200) {
          return left(true);
        } else {
          return right(response.statusMessage.toString());
        }
      } else {
        return right('There is no changes Detected');
      }
    } catch (error) {
      return right(error.toString());
    }
  }
}
