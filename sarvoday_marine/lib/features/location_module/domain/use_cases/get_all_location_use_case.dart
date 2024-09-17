import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/repositories/location_repository.dart';

class GetAllLocationsUseCase {
  final LocationRepository locationRepository;

  GetAllLocationsUseCase(this.locationRepository);

  Future<Either<List<LocationModel>, String>> call() async {
    return await locationRepository.getAllLocations();
  }
}
