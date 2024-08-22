import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/location_module/data/data_sources/local_data_source.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';

class LocationDataSourceImpl implements LocationDataSource {
  final Dio dio;

  LocationDataSourceImpl(this.dio);

  @override
  Future<Either<bool, CommonFailure>> addLocation(
      LocationParam locationParam) async {
    try {
      Map<String, dynamic> data = {
        'locationName': locationParam.locationName,
        'address': locationParam.address,
        'locationCode': locationParam.locationCode
      };
      final response = await dio.post(
          '${StringConst.backEndBaseURL}locations/addLocation',
          data: data);
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(ErrorFailure(response.statusMessage.toString()));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<bool, CommonFailure>> deleteLocation(String locationId) async {
    try {
      final response = await dio.delete(
          '${StringConst.backEndBaseURL}locations/deleteLocation/$locationId');
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(ErrorFailure(response.statusMessage.toString()));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<List<LocationModel>, CommonFailure>> getAllLocations() async {
    try {
      final response = await dio
          .get('${StringConst.backEndBaseURL}locations/getAllLocations');
      if (response.statusCode == 200) {
        final List<LocationModel> locationList = [];
        final jsonList = response.data;
        for (var item in jsonList) {
          locationList.add(LocationModel.fromJson(item));
        }
        return left(locationList);
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<LocationModel, CommonFailure>> updateLocation(
      String locationId, LocationParam locationParam) async {
    try {
      Map<String, dynamic> data = {};
      if (locationParam.locationName != null &&
          locationParam.locationName!.isNotEmpty) {
        data['locationName'] = locationParam.locationName ?? "";
      }

      if (locationParam.address != null &&
          locationParam.address!.toString().isNotEmpty) {
        data['address'] = locationParam.address;
      }

      if (locationParam.locationCode != null &&
          locationParam.locationCode!.toString().isNotEmpty) {
        data['locationCode'] = locationParam.locationCode;
      }

      if (data.isNotEmpty) {
        final response = await dio.put(
            '${StringConst.backEndBaseURL}locations/updateLocation/$locationId',
            data: data);
        if (response.statusCode == 200) {
          final LocationModel location = LocationModel.fromJson(response.data);
          return left(location);
        } else {
          return right(ErrorFailure(response.statusMessage.toString()));
        }
      } else {
        return right(ErrorFailure('There is no changes Detected'));
      }
    } catch (error) {
      return right(ErrorFailure(error.toString()));
    }
  }
}
