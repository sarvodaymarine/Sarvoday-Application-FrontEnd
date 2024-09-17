import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/api_handler/token_manager.dart';
import 'package:sarvoday_marine/core/utils/widgets/image_upload_aws_s3_service.dart';
import 'package:sarvoday_marine/features/report_module/data/models/container_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/image_config_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/get_report_use_case.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/get_service_report_use_case.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/update_report_use_case.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this.getReportUseCases, this.updateReportUseCases,
      this.getServiceReportUseCases)
      : super(ReportInitial());
  final GetReportUseCases getReportUseCases;
  final UpdateReportUseCases updateReportUseCases;
  final GetServiceReportUseCases getServiceReportUseCases;
  String user = '';
  Map<String, dynamic> images = {};

  getReportDetail(String orderId) async {
    var res = await getReportUseCases.call(orderId);
    res.fold((orders) {
      emit(StateOnSuccess(orders));
    }, (error) {
      emit(StateErrorGeneral(error.toString()));
    });
  }

  void loadServiceReport(String serviceId) async {
    emit(StateLoading());
    user = await TokenManager.getUserRole() ?? "";
    var res = await getServiceReportUseCases.call(serviceId);
    res.fold((serviceReport) {
      serviceReport.containerReports?.forEach((element) {
        images[element.containerId!] = getImageList(element);
      });
      emit(StateOnSuccess2(serviceReport));
    }, (error) {
      emit(StateErrorGeneral(error.toString()));
    });
  }

  updateServiceReport(String serviceId, String reportId,
      ServiceContainerModel serviceReport) async {
    emit(StateNoData());
    var res =
        await updateReportUseCases.call(reportId, serviceId, serviceReport);
    res.fold((location) {
      emit(StateOnCrudSuccess("Report updated SuccessFully"));
    }, (error) {
      emit(StateErrorGeneral(error.toString()));
    });
  }

  getImageList(ContainerModel? containerDetails) {
    final List<Map<String, dynamic>> imageList = [];

    final containerImages = containerDetails?.containerImages;
    if (containerImages != null) {
      for (ContainerImageModel imageConfig in containerImages) {
        String imageUrl = (imageConfig.imageUrlLink != null &&
                imageConfig.imageUrlLink!.isNotEmpty)
            ? imageConfig.imageUrlLink!
            : "";

        imageList.add({
          'imageName': imageConfig.imageName ?? 'Unknown',
          'imageUrl': imageUrl,
          'imagePath': imageConfig.imagePath ?? "",
          'imageFile': null,
          "error": "",
          'imageId': imageConfig.imageId ?? "",
        });
      }
    }
    return imageList;
  }

  uploadImageService(String reportId, String serviceId, String containerId,
      List<Map<String, dynamic>> imageList) async {
    emit(StateNoData());
    var response = await S3Service2()
        .uploadMultipleImages(reportId, serviceId, containerId, imageList);
    response.fold((l) {
      if (l == "success") {
        emit(StateImageUploaded('Images uploaded successfully'));
      } else {
        emit(StateErrorGeneral(l));
      }
    }, (r) {
      imageList = r;
      emit(StateImageUploaded(''));
    });
  }
}
