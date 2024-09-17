import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/location_module/domain/repositories/location_repository.dart';

class DeleteLocationUseCase {
  final LocationRepository locationRepository;

  DeleteLocationUseCase(this.locationRepository);

  Future<Either<bool, String>> call(String locationId) async {
    return await locationRepository.deleteLocation(locationId);
  }
}
