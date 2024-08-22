import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';

class UpdateServiceUseCase {
  final ServiceRepository serviceRepository;

  UpdateServiceUseCase(this.serviceRepository);

  Future<Either<ServiceModel, CommonFailure>> call(
      String serviceId, AddServiceParam addServiceParam) async {
    return await serviceRepository.updateService(serviceId, addServiceParam);
  }
}
