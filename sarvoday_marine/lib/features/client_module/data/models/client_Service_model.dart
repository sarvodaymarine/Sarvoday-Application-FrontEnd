class ClientServiceModel {
  String? _serviceName;
  String? _serviceId;
  double? _container1Price;
  double? _container2Price;
  double? _container3Price;
  double? _container4Price;

  ClientServiceModel({
    String? serviceName,
    String? serviceId,
    double? container1Price,
    double? container2Price,
    double? container3Price,
    double? container4Price,
  }) {
    _serviceName = serviceName;
    _serviceId = serviceId;
    _container1Price = container1Price;
    _container2Price = container2Price;
    _container3Price = container3Price;
    _container4Price = container4Price;
  }

  ClientServiceModel.fromJson(Map<String, dynamic> json) {
    _serviceName = json['serviceName'];
    _serviceId = json['serviceId'];
    _container1Price = (json['container1Price'] as num?)?.toDouble();
    _container2Price = (json['container2Price'] as num?)?.toDouble();
    _container3Price = (json['container3Price'] as num?)?.toDouble();
    _container4Price = (json['container4Price'] as num?)?.toDouble();
  }

  ClientServiceModel copyWith({
    String? serviceName,
    String? serviceId,
    double? container1Price,
    double? container2Price,
    double? container3Price,
    double? container4Price,
  }) =>
      ClientServiceModel(
        serviceName: serviceName ?? _serviceName,
        serviceId: serviceId ?? _serviceId,
        container1Price: container1Price ?? _container1Price,
        container2Price: container2Price ?? _container2Price,
        container3Price: container3Price ?? _container3Price,
        container4Price: container4Price ?? _container4Price,
      );

  String? get serviceName => _serviceName;
  String? get serviceId => _serviceId;
  double? get container1Price => _container1Price;
  double? get container2Price => _container2Price;
  double? get container3Price => _container3Price;
  double? get container4Price => _container4Price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceName'] = _serviceName;
    map['serviceId'] = _serviceId;
    map['container1Price'] = _container1Price;
    map['container2Price'] = _container2Price;
    map['container3Price'] = _container3Price;
    map['container4Price'] = _container4Price;
    return map;
  }
}
