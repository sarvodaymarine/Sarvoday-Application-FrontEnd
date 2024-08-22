import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/calendar_module/data/data_sources/calendar_data_source.dart';
import 'package:sarvoday_marine/features/calendar_module/data/data_sources/calendar_data_source_impl.dart';
import 'package:sarvoday_marine/features/calendar_module/data/repositories/calendar_repository_impl.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/add_sales_order_use_cases.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/get_all_sales_order_use_cases.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/get_sales_order_use_case.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/update_sales_order_use_cases.dart';
import 'package:sarvoday_marine/features/calendar_module/presentation/cubit/calendar_cubit.dart';

GetIt calendarSl = GetIt.instance;

Future<void> init() async {
  calendarSl.registerFactory(() =>
      CalendarCubit(calendarSl(), calendarSl(), calendarSl(), calendarSl()));

  calendarSl
      .registerLazySingleton(() => GetAllSalesOrderUseCases(calendarSl()));
  calendarSl.registerLazySingleton(() => AddSalesOrderUseCase(calendarSl()));
  calendarSl.registerLazySingleton(() => GetSalesOrderUseCases(calendarSl()));
  calendarSl.registerLazySingleton(() => UpdateSalesOrderUseCase(calendarSl()));

  calendarSl.registerLazySingleton<CalendarRepository>(
      () => CalendarRepositoryImpl(calendarSl()));

  calendarSl.registerFactory<CalendarDataSource>(
      () => CalendarDataSourceImpl(calendarSl()));
}
