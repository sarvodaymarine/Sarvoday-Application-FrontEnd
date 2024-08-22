import 'package:sarvoday_marine/features/authentication_module/data/models/user_model.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_Service_model.dart';

class ClientModel {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _userId;
  String? _clientAddress;
  UserModel? _userDetail;
  bool? _isDeleted;
  String? _updatedAt;
  String? _createdAt;
  List<ClientServiceModel>? _services;

  ClientModel(
      {String? id,
      String? firstName,
      String? lastName,
      String? clientAddress,
      String? userId,
      bool? isDeleted,
      UserModel? userDetail,
      List<ClientServiceModel>? services,
      String? updatedAt,
      String? createdAt}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _clientAddress = clientAddress;
    _userId = userId;
    _userDetail = userDetail;
    _isDeleted = isDeleted;
    _services = services;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
  }

  ClientModel.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _clientAddress = json['clientAddress'];
    _userId = json['userId'];
    _isDeleted = json['isDeleted'];
    _userDetail = json['userDetail'] != null
        ? UserModel.fromJson(json['userDetail'])
        : null;
    if (json['services'] != null) {
      _services = (json['services'] as List)
          .map((i) => ClientServiceModel.fromJson(i))
          .toList();
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  ClientModel copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          String? clientAddress,
          UserModel? userDetail,
          String? userId,
          bool? isDeleted,
          List<ClientServiceModel>? services,
          String? updatedAt,
          String? createdAt}) =>
      ClientModel(
          id: id ?? _id,
          firstName: firstName ?? _firstName,
          lastName: lastName ?? _lastName,
          clientAddress: clientAddress ?? _clientAddress,
          userId: userId ?? _userId,
          userDetail: userDetail ?? _userDetail,
          isDeleted: isDeleted ?? _isDeleted,
          services: services ?? _services,
          updatedAt: updatedAt ?? _updatedAt,
          createdAt: createdAt ?? _createdAt);

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get userId => _userId;

  UserModel? get userDetail => _userDetail;

  String? get clientAddress => _clientAddress;

  List<ClientServiceModel>? get services => _services;

  bool? get isDeleted => _isDeleted;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['clientAddress'] = _clientAddress;
    map['userId'] = _userId;
    map['isDeleted'] = _isDeleted;
    if (_userDetail != null) {
      map['userDetail'] = _userDetail!.toJson();
    }
    if (_services != null) {
      map['services'] = _services!.map((service) => service.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
