import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';

class GenerateServiceReportUseCases {
  final ReportRepository reportRepository;

  GenerateServiceReportUseCases(this.reportRepository);

  Future<Either<ReportModel, String>> call(
      String reportId, String serviceId) async {
    return await reportRepository.generateServiceReport(reportId, serviceId);
  }
}
