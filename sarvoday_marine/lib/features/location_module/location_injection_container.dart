import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/location_module/data/data_sources/local_data_source.dart';
import 'package:sarvoday_marine/features/location_module/data/data_sources/local_data_source_impl.dart';
import 'package:sarvoday_marine/features/location_module/data/repositories/location_repository_impl.dart';
import 'package:sarvoday_marine/features/location_module/domain/repositories/location_repository.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/add_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/delete_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/get_all_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/domain/use_cases/update_location_use_case.dart';
import 'package:sarvoday_marine/features/location_module/presentation/cubit/location_cubit.dart';

GetIt locationSl = GetIt.instance;

Future<void> init() async {
  locationSl.registerFactory(() =>
      LocationCubit(locationSl(), locationSl(), locationSl(), locationSl()));

  locationSl.registerLazySingleton(() => GetAllLocationsUseCase(locationSl()));
  locationSl.registerLazySingleton(() => AddLocationUseCase(locationSl()));
  locationSl.registerLazySingleton(() => DeleteLocationUseCase(locationSl()));
  locationSl.registerLazySingleton(() => UpdateLocationUseCase(locationSl()));

  locationSl.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(locationSl()));

  locationSl.registerFactory<LocationDataSource>(
      () => LocationDataSourceImpl(locationSl()));
}
