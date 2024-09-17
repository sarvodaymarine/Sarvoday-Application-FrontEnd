import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';
import 'package:sarvoday_marine/features/report_module/domain/repositories/report_repository.dart';

class UpdateReportUseCases {
  final ReportRepository reportRepository;

  UpdateReportUseCases(this.reportRepository);

  Future<Either<String, ReportModel>> call(String reportId, String serviceId,
      ServiceContainerModel serviceReport) async {
    return await reportRepository.updateReport(
        reportId, serviceId, serviceReport);
  }
}

class ReportParam {
  final String? orderId;
  final List<String>? serviceContainerModel;

  ReportParam(this.orderId, this.serviceContainerModel);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (serviceContainerModel != null) {
      map['serviceReports'] =
          serviceContainerModel?.map((v) => v.toString()).toList();
    }
    return map;
  }
}
