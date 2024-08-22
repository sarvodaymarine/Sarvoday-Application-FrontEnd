import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/location_module/data/data_sources/local_data_source.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/repositories/location_repository.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;

  LocationRepositoryImpl(this.locationDataSource);

  @override
  Future<Either<bool, CommonFailure>> addLocation(
      LocationParam locationParam) async {
    return await locationDataSource.addLocation(locationParam);
  }

  @override
  Future<Either<bool, CommonFailure>> deleteLocation(String locationId) async {
    return await locationDataSource.deleteLocation(locationId);
  }

  @override
  Future<Either<List<LocationModel>, CommonFailure>> getAllLocations() async {
    return await locationDataSource.getAllLocations();
  }

  @override
  Future<Either<LocationModel, CommonFailure>> updateLocation(
      String serviceId, LocationParam locationParam) async {
    return await locationDataSource.updateLocation(serviceId, locationParam);
  }
}
