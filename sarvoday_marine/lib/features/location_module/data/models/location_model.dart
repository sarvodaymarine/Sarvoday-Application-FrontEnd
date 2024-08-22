class LocationModel {
  LocationModel(
      {String? id,
      String? locationName,
      String? locationCode,
      String? address,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _locationName = locationName;
    _locationCode = locationCode;
    _address = address;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  LocationModel.fromJson(dynamic json) {
    _id = json['id'];
    _locationName = json['locationName'];
    _locationCode = json['locationCode'];
    _address = json['address'];
    _updatedAt = json['updatedAt'];
    _createdAt = json['createdAt'];
  }

  String? _id;
  String? _locationName;
  String? _locationCode;
  String? _address;
  String? _updatedAt;
  String? _createdAt;

  LocationModel copyWith(
          {String? id,
          String? locationName,
          String? locationCode,
          String? address,
          String? createdAt,
          String? updatedAt}) =>
      LocationModel(
          id: id ?? _id,
          locationName: locationName ?? _locationName,
          locationCode: locationCode ?? _locationCode,
          address: address ?? _address,
          createdAt: createdAt ?? _createdAt);

  String? get id => _id;

  String? get locationName => _locationName;

  String? get address => _address;

  String? get locationCode => _locationCode;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['locationName'] = _locationName;
    map['locationCode'] = _locationCode;
    map['address'] = _address;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;

    return map;
  }
}
