import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

abstract class ServiceRepository {
  Future<Either<List<ServiceModel>, String>> getAllServices();

  Future<Either<bool, String>> addService(AddServiceParam addServiceParam);

  Future<Either<bool, String>> deleteService(String serviceId);

  Future<Either<ServiceModel, String>> updateService(
      String serviceId, AddServiceParam addServiceParam);
}
