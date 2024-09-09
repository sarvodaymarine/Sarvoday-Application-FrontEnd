import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/report_module/data/data_sources/report_data_source.dart';
import 'package:sarvoday_marine/features/report_module/data/data_sources/report_data_source_impl.dart';
import 'package:sarvoday_marine/features/report_module/data/repositories/report_repository_impl.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/get_report_use_case.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/get_service_report_use_case.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/update_report_use_case.dart';
import 'package:sarvoday_marine/features/report_module/presentation/cubit/report_cubit.dart';

GetIt reportSl = GetIt.instance;

Future<void> init() async {
  reportSl
      .registerFactory(() => ReportCubit(reportSl(), reportSl(), reportSl()));

  reportSl.registerLazySingleton(() => GetReportUseCases(reportSl()));
  reportSl.registerLazySingleton(() => UpdateReportUseCases(reportSl()));
  reportSl.registerLazySingleton(() => GetServiceReportUseCases(reportSl()));

  reportSl.registerLazySingleton<ReportRepository>(
      () => ReportRepositoryImpl(reportSl()));

  reportSl.registerFactory<ReportDataSource>(
      () => ReportDataSourceImpl(reportSl()));
}
