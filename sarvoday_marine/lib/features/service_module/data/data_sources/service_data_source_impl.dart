import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/service_module/data/data_sources/service_data_source.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

class ServiceDataSourceImpl implements ServiceDataSource {
  final Dio dio;

  ServiceDataSourceImpl(this.dio);

  @override
  Future<Either<bool, CommonFailure>> addService(
      AddServiceParam addServiceParam) async {
    try {
      Map<String, dynamic> data = {
        'serviceName': addServiceParam.serviceName,
        'container1Price': addServiceParam.container1Price,
        'container2Price': addServiceParam.container2Price,
        'container3Price': addServiceParam.container3Price,
        'container4Price': addServiceParam.container4Price,
        'serviceImage': addServiceParam.images,
      };
      final response = await dio
          .post('${StringConst.backEndBaseURL}services/addService', data: data);
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
  Future<Either<bool, CommonFailure>> deleteService(String serviceId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}services/deleteService/$serviceId');
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
  Future<Either<List<ServiceModel>, CommonFailure>> getAllServices() async {
    try {
      final response =
          await dio.get('${StringConst.backEndBaseURL}services/getAllService');
      if (response.statusCode == 200) {
        final List<ServiceModel> services = [];
        final jsonList = response.data;
        for (var item in jsonList) {
          services.add(ServiceModel.fromJson(item));
        }
        return left(services);
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<ServiceModel, CommonFailure>> getServiceById() {
    // TODO: implement getServiceById
    throw UnimplementedError();
  }

  @override
  Future<Either<ServiceModel, CommonFailure>> getServiceByServiceName() {
    // TODO: implement getServiceByServiceName
    throw UnimplementedError();
  }

  @override
  Future<Either<ServiceModel, CommonFailure>> updateService(
      String serviceId, AddServiceParam addServiceParam) async {
    try {
      Map<String, dynamic> data = {};
      if (addServiceParam.serviceName != null &&
          addServiceParam.serviceName!.isNotEmpty) {
        data['serviceName'] = addServiceParam.serviceName ?? "";
      }

      if (addServiceParam.container1Price != null &&
          addServiceParam.container1Price!.toString().isNotEmpty) {
        data['container1Price'] = addServiceParam.container1Price;
      }
      if (addServiceParam.container2Price != null &&
          addServiceParam.container2Price!.toString().isNotEmpty) {
        data['container2Price'] = addServiceParam.container2Price;
      }
      if (addServiceParam.container3Price != null &&
          addServiceParam.container3Price!.toString().isNotEmpty) {
        data['container3Price'] = addServiceParam.container3Price;
      }
      if (addServiceParam.container4Price != null &&
          addServiceParam.container4Price!.toString().isNotEmpty) {
        data['container4Price'] = addServiceParam.container4Price;
      }
      if (addServiceParam.images != null) {
        data["serviceImage"] = addServiceParam.images;
      }
      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}services/updateService/$serviceId',
            data: data);
        if (response.statusCode == 200) {
          final ServiceModel services = ServiceModel.fromJson(response.data);
          return left(services);
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
