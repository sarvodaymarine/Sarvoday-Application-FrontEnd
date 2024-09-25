import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/client_module/data/data_sources/client_data_source.dart';
import 'package:sarvoday_marine/features/client_module/data/data_sources/client_data_source_impl.dart';
import 'package:sarvoday_marine/features/client_module/data/repositories/client_repository_impl.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/delete_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/disable_client_auth_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/get_all_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/update_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/presentation/cubit/client_cubit.dart';

GetIt clientSl = GetIt.instance;

Future<void> init() async {
  clientSl.registerFactory(() => ClientCubit(
      clientSl(), clientSl(), clientSl(), clientSl(), clientSl(), clientSl()));

  clientSl.registerLazySingleton(() => GetAllClientsUseCase(clientSl()));
  clientSl.registerLazySingleton(() => AddClientUseCase(clientSl()));
  clientSl.registerLazySingleton(() => DeleteClientUseCase(clientSl()));
  clientSl.registerLazySingleton(() => UpdateClientUseCase(clientSl()));
  clientSl
      .registerLazySingleton(() => DisableEnabledClientAuthUseCase(clientSl()));
  clientSl.registerLazySingleton<ClientRepository>(
      () => ClientRepositoryImpl(clientSl()));

  clientSl.registerFactory<ClientDataSource>(
      () => ClientDataSourceImpl(clientSl()));
}
