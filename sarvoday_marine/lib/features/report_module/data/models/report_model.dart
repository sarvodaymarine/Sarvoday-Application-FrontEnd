class ReportModel {
  String? _id;
  String? _orderId;
  bool? _isReviewed;
  bool? _isSubmitted;
  bool? _isEmailSent;
  List<ServiceReportMetaData>? _serviceReports;

  ReportModel(
      {String? id,
      String? orderId,
      bool? isEmailSent,
      bool? isSubmitted,
      bool? isReviewed,
      List<ServiceReportMetaData>? serviceReports}) {
    _id = id;
    _orderId = orderId;
    _isReviewed = isReviewed;
    _isEmailSent = isEmailSent;
    _isSubmitted = isSubmitted;
    _serviceReports = serviceReports;
  }

  ReportModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _orderId = json['orderId'];
    _isReviewed = json['isReviewed'];
    _isEmailSent = json['isEmailSent'];
    _isSubmitted = json['isSubmitted'];
    _serviceReports = (json['serviceReports'] as List<dynamic>?)
        ?.map((item) => ServiceReportMetaData.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['orderId'] = _orderId;
    map['serviceReports'] = _serviceReports
        ?.map((ServiceReportMetaData container) => container.toJson())
        .toList();
    map['isReviewed'] = _isReviewed;
    map['isEmailSended'] = _isEmailSent;
    map['isSubmited'] = _isSubmitted;
    return map;
  }

  ReportModel copyWith(
      {String? id,
      String? serviceId,
      bool? isEmailSent,
      bool? isSubmitted,
      bool? isReviewed,
      List<ServiceReportMetaData>? serviceReports}) {
    return ReportModel(
      id: id ?? _id,
      orderId: serviceId ?? _orderId,
      isReviewed: isReviewed ?? _isReviewed,
      isEmailSent: isEmailSent ?? _isEmailSent,
      isSubmitted: isSubmitted ?? _isSubmitted,
      serviceReports: serviceReports ?? _serviceReports,
    );
  }

  String? get id => _id;

  String? get orderId => _orderId;

  bool? get isReviewed => _isReviewed;

  bool? get isEmailSent => _isEmailSent;

  bool? get isSubmitted => _isSubmitted;

  List<ServiceReportMetaData>? get serviceReports => _serviceReports;
}

class ServiceReportMetaData {
  String? _serviceName;
  String? _reportStatus;
  String? _serviceId;
  String? _id;

  ServiceReportMetaData(
      {String? serviceName,
      String? reportStatus,
      String? serviceId,
      String? id}) {
    _serviceName = serviceName;
    _reportStatus = reportStatus;
    _serviceId = serviceId;
    _id = id;
  }

  ServiceReportMetaData.fromJson(Map<String, dynamic> json) {
    _id:
    json['id'];
    _serviceName = json['serviceName'];
    _reportStatus = json['reportStatus'];
    _serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['serviceName'] = _serviceName;
    map['reportStatus'] = _reportStatus;
    map['serviceId'] = _serviceId;
    return map;
  }

  ServiceReportMetaData copyWith(
      {String? serviceName,
      String? reportStatus,
      String? serviceId,
      String? id}) {
    return ServiceReportMetaData(
      id: id ?? _id,
      serviceName: serviceName ?? _serviceName,
      reportStatus: reportStatus ?? _reportStatus,
      serviceId: serviceId ?? _serviceId,
    );
  }

  String? get serviceName => _serviceName;

  String? get reportStatus => _reportStatus;

  String? get serviceId => _serviceId;

  String? get id => _id;
}
