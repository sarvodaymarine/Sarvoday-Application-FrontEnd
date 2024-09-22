import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';

abstract class ReportRepository {
  Future<Either<ReportModel, String>> getReport(String id);

  Future<Either<ServiceContainerModel, String>> getServiceReport(
      String serviceId);

  Future<Either<String, ServiceContainerModel>> updateReport(String reportId,
      String serviceId, ServiceContainerModel param, bool isReviewed);
}
