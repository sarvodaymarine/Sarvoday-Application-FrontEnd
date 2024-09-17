import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';

class GetServiceReportUseCases {
  final ReportRepository reportRepository;

  GetServiceReportUseCases(this.reportRepository);

  Future<Either<ServiceContainerModel, String>> call(String serviceId) async {
    return await reportRepository.getServiceReport(serviceId);
  }
}
