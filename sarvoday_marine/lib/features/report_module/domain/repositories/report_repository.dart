import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';

abstract class ReportRepository {
  Future<Either<ReportModel, CommonFailure>> getReport(String id);

  Future<Either<ServiceContainerModel, CommonFailure>> getServiceReport(
      String serviceId);

  Future<Either<CommonFailure, ReportModel>> updateReport(
      String reportId, String serviceId, ServiceContainerModel param);
}
