import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/service_module/data/data_sources/service_data_source.dart';
import 'package:sarvoday_marine/features/service_module/data/data_sources/service_data_source_impl.dart';
import 'package:sarvoday_marine/features/service_module/data/repositories/service_repository_impl.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/delete_service_use_case.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/get_all_services_use__case.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/update_service_use_case.dart';
import 'package:sarvoday_marine/features/service_module/presentation/cubit/service_cubit.dart';

GetIt servicesSl = GetIt.instance;

Future<void> init() async {
  servicesSl.registerFactory(() =>
      ServiceCubit(servicesSl(), servicesSl(), servicesSl(), servicesSl()));

  servicesSl.registerLazySingleton(() => GetAllServicesUseCase(servicesSl()));
  servicesSl.registerLazySingleton(() => AddServiceUseCase(servicesSl()));
  servicesSl.registerLazySingleton(() => DeleteServiceUseCase(servicesSl()));
  servicesSl.registerLazySingleton(() => UpdateServiceUseCase(servicesSl()));

  servicesSl.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(servicesSl()));

  servicesSl.registerFactory<ServiceDataSource>(
      () => ServiceDataSourceImpl(servicesSl()));
}
