import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/location_module/domain/repositories/location_repository.dart';

class AddLocationUseCase {
  final LocationRepository locationRepository;

  AddLocationUseCase(this.locationRepository);

  Future<Either<bool, String>> call(LocationParam locationParam) async {
    return await locationRepository.addLocation(locationParam);
  }
}

class LocationParam {
  String? locationName;
  String? address;
  String? locationCode;

  LocationParam(this.locationName, this.address, this.locationCode);
}
