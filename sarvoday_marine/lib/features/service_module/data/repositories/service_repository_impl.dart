import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/service_module/data/data_sources/service_data_source.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataSource serviceDataSource;

  ServiceRepositoryImpl(this.serviceDataSource);

  @override
  Future<Either<bool, CommonFailure>> addService(
      AddServiceParam addServiceParam) async {
    return await serviceDataSource.addService(addServiceParam);
  }

  @override
  Future<Either<bool, CommonFailure>> deleteService(String serviceId) async {
    return await serviceDataSource.deleteService(serviceId);
  }

  @override
  Future<Either<List<ServiceModel>, CommonFailure>> getAllServices() async {
    return await serviceDataSource.getAllServices();
  }

  @override
  Future<Either<ServiceModel, CommonFailure>> getServiceById() async {
    return await serviceDataSource.getServiceById();
  }

  @override
  Future<Either<ServiceModel, CommonFailure>> getServiceByServiceName() async {
    return await serviceDataSource.getServiceByServiceName();
  }

  @override
  Future<Either<ServiceModel, CommonFailure>> updateService(
      String serviceId, AddServiceParam addServiceParam) async {
    return await serviceDataSource.updateService(serviceId, addServiceParam);
  }
}
