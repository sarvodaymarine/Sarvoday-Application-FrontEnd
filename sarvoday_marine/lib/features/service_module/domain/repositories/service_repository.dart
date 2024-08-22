import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

abstract class ServiceRepository {
  Future<Either<List<ServiceModel>, CommonFailure>> getAllServices();

  Future<Either<ServiceModel, CommonFailure>> getServiceById();

  Future<Either<ServiceModel, CommonFailure>> getServiceByServiceName();

  Future<Either<bool, CommonFailure>> addService(
      AddServiceParam addServiceParam);

  Future<Either<bool, CommonFailure>> deleteService(String serviceId);

  Future<Either<ServiceModel, CommonFailure>> updateService(
      String serviceId, AddServiceParam addServiceParam);
}
