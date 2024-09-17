import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';

class DeleteServiceUseCase {
  final ServiceRepository serviceRepository;

  DeleteServiceUseCase(this.serviceRepository);

  Future<Either<bool, String>> call(String serviceId) async {
    return await serviceRepository.deleteService(serviceId);
  }
}
