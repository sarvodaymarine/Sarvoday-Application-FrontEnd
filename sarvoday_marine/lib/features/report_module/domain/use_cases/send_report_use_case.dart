import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';

class SendReportUseCases {
  final ReportRepository reportRepository;

  SendReportUseCases(this.reportRepository);

  Future<Either<bool, String>> call(String serviceId) async {
    return await reportRepository.sendReport(serviceId);
  }
}
