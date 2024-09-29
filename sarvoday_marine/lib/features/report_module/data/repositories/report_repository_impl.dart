import 'package:dartz/dartz.dart';
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
  Future<Either<String, ServiceContainerModel>> updateReport(String reportId,
      String serviceId, ServiceContainerModel param, bool isReviewed) async {
    return await reportDataSource.updateReport(
        reportId, serviceId, param, isReviewed);
  }

  @override
  Future<Either<ServiceContainerModel, String>> getServiceReport(
      String serviceId) async {
    return await reportDataSource.getServiceReport(serviceId);
  }

  @override
  Future<Either<ReportModel, String>> generateServiceReport(
      String reportId, String serviceId) async {
    return await reportDataSource.generateServiceReport(reportId, serviceId);
  }

  @override
  Future<Either<bool, String>> sendReport(String reportId) async {
    return await reportDataSource.sendReport(reportId);
  }
}
