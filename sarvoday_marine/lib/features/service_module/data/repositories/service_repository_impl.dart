import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/service_module/data/data_sources/service_data_source.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataSource serviceDataSource;

  ServiceRepositoryImpl(this.serviceDataSource);

  @override
  Future<Either<bool, String>> addService(
      AddServiceParam addServiceParam) async {
    return await serviceDataSource.addService(addServiceParam);
  }

  @override
  Future<Either<bool, String>> deleteService(String serviceId) async {
    return await serviceDataSource.deleteService(serviceId);
  }

  @override
  Future<Either<List<ServiceModel>, String>> getAllServices() async {
    return await serviceDataSource.getAllServices();
  }

  @override
  Future<Either<ServiceModel, String>> updateService(
      String serviceId, AddServiceParam addServiceParam) async {
    return await serviceDataSource.updateService(serviceId, addServiceParam);
  }
}
