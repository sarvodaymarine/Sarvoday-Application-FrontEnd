import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/report_module/data/data_sources/report_data_source.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource reportDataSource;

  ReportRepositoryImpl(this.reportDataSource);

  @override
  Future<Either<ReportModel, String>> getReport(String id) async {
    return await reportDataSource.getReport(id);
  }

  @override
  Future<Either<String, ReportModel>> updateReport(
      String reportId, String serviceId, ServiceContainerModel param) async {
    return await reportDataSource.updateReport(reportId, serviceId, param);
  }

  @override
  Future<Either<ServiceContainerModel, String>> getServiceReport(
      String serviceId) async {
    return await reportDataSource.getServiceReport(serviceId);
  }
}
