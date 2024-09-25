import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/features/authentication_module/data/data_sources/sign_in_data_source.dart';
import 'package:sarvoday_marine/features/authentication_module/data/data_sources/sign_in_data_source_impl.dart';
import 'package:sarvoday_marine/features/authentication_module/data/repositories/sign_in_repository_impl.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/repositories/sign_in_repository.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/use_cases/change_password_use_case.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/use_cases/login_use_case.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/use_cases/reset_password_use_case.dart';
import 'package:sarvoday_marine/features/authentication_module/presentation/cubit/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt authenticationSl = GetIt.instance;

Future<void> init() async {
  authenticationSl.registerFactory(
      () => SignInCubit(authenticationSl(), authenticationSl()));

  authenticationSl
      .registerLazySingleton(() => LoginUseCase(authenticationSl()));
  authenticationSl
      .registerLazySingleton(() => ChangePasswordUseCase(authenticationSl()));
  authenticationSl
      .registerLazySingleton(() => ResetPasswordUseCase(authenticationSl()));

  authenticationSl.registerLazySingleton<SignInRepository>(
      () => SignInRepositoryImpl(authenticationSl()));

  authenticationSl.registerFactory<SignInDataSource>(
      () => SignInDataSourceImpl(authenticationSl(), authenticationSl()));

  authenticationSl.registerFactory(() => DioClient.getInstance());
  final sharedPreferences = await SharedPreferences.getInstance();
  authenticationSl.registerLazySingleton(() => sharedPreferences);
}
