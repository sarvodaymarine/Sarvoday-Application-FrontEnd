import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/repositories/location_repository.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';

class UpdateLocationUseCase {
  final LocationRepository locationRepository;

  UpdateLocationUseCase(this.locationRepository);

  Future<Either<LocationModel, String>> call(
      String locationId, LocationParam locationParam) async {
    return await locationRepository.updateLocation(locationId, locationParam);
  }
}
