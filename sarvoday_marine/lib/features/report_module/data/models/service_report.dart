import 'package:sarvoday_marine/features/report_module/data/models/container_model.dart';

class ServiceContainerModel {
  String? _serviceName;
  bool? _isEdited;
  String? _reportStatus;
  List<ContainerModel>? _containerReports;

  ServiceContainerModel(
      {String? serviceName,
      String? reportStatus,
      List<ContainerModel>? containerReports,
      bool? isEdited}) {
    _serviceName = serviceName;
    _reportStatus = reportStatus;
    _isEdited = isEdited;
    _containerReports = containerReports;
  }

  ServiceContainerModel.fromJson(Map<String, dynamic> json) {
    _serviceName = json['serviceName'];
    _reportStatus = json['reportStatus'];
    _isEdited = json['isEdited'];
    _containerReports = (json['containerReports'] as List<dynamic>?)
        ?.map((item) => ContainerModel.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceName'] = _serviceName;
    map['isEdited'] = _isEdited;
    map['reportStatus'] = _reportStatus;
    map['containerReports'] = _containerReports
        ?.map((ContainerModel container) => container.toJson())
        .toList();
    return map;
  }

  ServiceContainerModel copyWith(
      {String? serviceName,
      bool? isEdited,
      String? reportStatus,
      List<ContainerModel>? containerReports}) {
    return ServiceContainerModel(
      isEdited: isEdited ?? _isEdited,
      serviceName: serviceName ?? _serviceName,
      reportStatus: reportStatus ?? _reportStatus,
      containerReports: containerReports ?? _containerReports,
    );
  }

  String? get serviceName => _serviceName;

  String? get reportStatus => _reportStatus;

  bool? get isEdited => _isEdited;

  List<ContainerModel>? get containerReports => _containerReports;
}
