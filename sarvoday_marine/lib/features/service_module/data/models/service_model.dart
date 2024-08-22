class ServiceModel {
  ServiceModel(
      {String? id,
      String? serviceName,
      double? container1Price,
      double? container2Price,
      double? container3Price,
      double? container4Price,
      List<ServiceImageConfig>? serviceImage,
      String? updatedAt,
      String? createdAt}) {
    _id = id;
    _serviceName = serviceName;
    _serviceImage = serviceImage;
    _container1Price = container1Price;
    _container2Price = container2Price;
    _container3Price = container3Price;
    _container4Price = container4Price;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
  }

  ServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _serviceName = json['serviceName'];
    _updatedAt = json['updatedAt'];
    _createdAt = json['createdAt'];
    _container1Price = json['container1Price'] is int
        ? double.parse(json['container1Price'].toString())
        : json['container1Price'];
    _container2Price = json['container2Price'] is int
        ? double.parse(json['container2Price'].toString())
        : json['container2Price'];
    _container3Price = json['container3Price'] is int
        ? double.parse(json['container3Price'].toString())
        : json['container3Price'];
    _container4Price = json['container4Price'] is int
        ? double.parse(json['container4Price'].toString())
        : json['container4Price'];
    _serviceImage = (json['serviceImage'] as List<dynamic>?)
        ?.map((item) => ServiceImageConfig.fromJson(item))
        .toList();
  }

  String? _id;
  String? _serviceName;
  double? _container1Price;
  double? _container2Price;
  double? _container3Price;
  double? _container4Price;
  List<ServiceImageConfig>? _serviceImage;
  String? _updatedAt;
  String? _createdAt;

  ServiceModel copyWith(
          {String? id,
          String? serviceName,
          double? container1Price,
          double? container2Price,
          double? container3Price,
          double? container4Price,
          List<ServiceImageConfig>? serviceImage,
          String? updatedAt,
          String? createdAt}) =>
      ServiceModel(
          id: id ?? _id,
          serviceName: serviceName ?? _serviceName,
          container1Price: container1Price ?? _container1Price,
          container2Price: container2Price ?? _container2Price,
          container3Price: container3Price ?? _container3Price,
          container4Price: container4Price ?? _container4Price,
          serviceImage: serviceImage ?? _serviceImage,
          updatedAt: updatedAt ?? _updatedAt,
          createdAt: createdAt ?? _createdAt);

  String? get id => _id;

  String? get serviceName => _serviceName;

  List<ServiceImageConfig>? get serviceImage => _serviceImage;

  double? get container1Price => _container1Price;

  double? get container2Price => _container2Price;

  double? get container3Price => _container3Price;

  double? get container4Price => _container4Price;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['serviceName'] = _serviceName;
    map['container1Price'] = _container1Price;
    map['container2Price'] = _container2Price;
    map['container3Price'] = _container3Price;
    map['container4Price'] = _container4Price;
    map['serviceImage'] = _serviceImage?.map((item) => item.toJson()).toList();
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

class ServiceImageConfig {
  ServiceImageConfig({
    this.imageName,
    this.imageCount,
  });

  String? imageName;
  int? imageCount;

  factory ServiceImageConfig.fromJson(Map<String, dynamic> json) {
    return ServiceImageConfig(
      imageName: json['imageName'],
      imageCount: json['imageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageName'] = imageName;
    map['imageCount'] = imageCount;
    return map;
  }
}
