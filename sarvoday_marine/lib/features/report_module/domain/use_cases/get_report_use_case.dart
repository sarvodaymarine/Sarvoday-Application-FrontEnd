import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';

class GetReportUseCases {
  final ReportRepository reportRepository;

  GetReportUseCases(this.reportRepository);

  Future<Either<ReportModel, CommonFailure>> call(String id) async {
    return await reportRepository.getReport(id);
  }
}
