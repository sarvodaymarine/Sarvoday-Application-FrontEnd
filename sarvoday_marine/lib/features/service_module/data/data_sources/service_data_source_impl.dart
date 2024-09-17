import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/service_module/data/data_sources/service_data_source.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

class ServiceDataSourceImpl implements ServiceDataSource {
  final DioClient dio;

  ServiceDataSourceImpl(this.dio);

  @override
  Future<Either<bool, String>> addService(
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
        return right(CommonMethods.commonErrorHandler(response));
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<bool, String>> deleteService(String serviceId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}services/deleteService/$serviceId');
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(response.statusMessage.toString());
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<List<ServiceModel>, String>> getAllServices() async {
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
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<ServiceModel, String>> updateService(
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
      data["serviceImage"] = addServiceParam.images;
      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}services/updateService/$serviceId',
            data: data);
        if (response.statusCode == 200) {
          final ServiceModel services = ServiceModel.fromJson(response.data);
          return left(services);
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
