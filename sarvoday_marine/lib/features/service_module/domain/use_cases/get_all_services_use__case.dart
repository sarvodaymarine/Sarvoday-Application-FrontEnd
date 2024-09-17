import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';

class GetAllServicesUseCase {
  final ServiceRepository serviceRepository;

  GetAllServicesUseCase(this.serviceRepository);

  Future<Either<List<ServiceModel>, String>> call() async {
    return await serviceRepository.getAllServices();
  }
}
