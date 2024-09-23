import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';

abstract class LocationRepository {
  Future<Either<List<LocationModel>, String>> getAllLocations();

  Future<Either<bool, String>> addLocation(LocationParam locationParam);

  Future<Either<bool, String>> deleteLocation(String serviceId);

  Future<Either<LocationModel, String>> updateLocation(
      String serviceId, LocationParam locationParam);
}
