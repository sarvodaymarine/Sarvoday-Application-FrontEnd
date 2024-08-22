import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/features/location_module/data/models/location_model.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/delete_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/get_all_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/update_location_use_case.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this.getAllLocationsUseCase, this.addLocationUseCase,
      this.deleteLocationUseCase, this.updateLocationUseCase)
      : super(LocationInitial());

  final GetAllLocationsUseCase getAllLocationsUseCase;
  final AddLocationUseCase addLocationUseCase;
  final DeleteLocationUseCase deleteLocationUseCase;
  final UpdateLocationUseCase updateLocationUseCase;

  getAllLocations({bool needFetchData = false}) async {
    if (needFetchData) {
      emit(LocationStateLoading());
    }
    var res = await getAllLocationsUseCase.call();
    res.fold((locations) {
      emit(LocationStateOnSuccess(locations));
    }, (error) {
      emit(LocationStateErrorGeneral(error.toString()));
    });
  }

  addLocation(String locationName, String address, String locationCode) async {
    emit(LocationStateNoData());
    var res = await addLocationUseCase
        .call(LocationParam(locationName, address, locationCode));
    res.fold((location) {
      emit(LocationStateOnCrudSuccess("Location Added SuccessFully"));
      getAllLocations(needFetchData: true);
    }, (error) {
      emit(LocationStateErrorGeneral(error.toString()));
    });
  }

  updatedEmployeeLocationFields(List<LocationModel>? locations) {
    emit(LocationStateOnSuccess(locations));
  }

  deleteLocation(String locationId) async {
    emit(LocationStateNoData());
    var res = await deleteLocationUseCase.call(locationId);
    res.fold((services) {
      emit(LocationStateOnCrudSuccess("Location deleted SuccessFully!"));
      getAllLocations(needFetchData: true);
    }, (error) {
      emit(LocationStateErrorGeneral(error.toString()));
    });
  }

  updatedLocation(String locationId, String locationName, String address,
      String locationCode) async {
    emit(LocationStateNoData());
    if (locationId.isNotEmpty) {
      if (locationName.isEmpty && address.isEmpty && locationCode.isEmpty) {
        emit(LocationStateErrorGeneral(
            'Location data cannot be empty. Please provide the necessary information.'));
      } else {
        var res = await updateLocationUseCase.call(
            locationId, LocationParam(locationName, address, locationCode));
        res.fold((location) {
          emit(LocationStateOnCrudSuccess("Location updated SuccessFully"));
          getAllLocations(needFetchData: true);
        }, (error) {
          emit(LocationStateErrorGeneral(error.toString()));
        });
      }
    } else {
      emit(LocationStateErrorGeneral("Something went to wrong!"));
    }
  }
}
