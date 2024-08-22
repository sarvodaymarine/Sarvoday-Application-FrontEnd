import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';

abstract class LocationDataSource {
  Future<Either<List<LocationModel>, CommonFailure>> getAllLocations();

  Future<Either<bool, CommonFailure>> addLocation(LocationParam locationParam);

  Future<Either<bool, CommonFailure>> deleteLocation(String serviceId);

  Future<Either<LocationModel, CommonFailure>> updateLocation(
      String serviceId, LocationParam locationParam);
}
