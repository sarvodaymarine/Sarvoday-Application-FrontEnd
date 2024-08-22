import 'package:sarvoday_marine/features/authentication_module/data/models/user_model.dart';

class EmployeeModel {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _userId;
  bool? _isDeleted;
  String? _userRole;
  String? _updatedAt;
  String? _createdAt;
  UserModel? _userDetail;

  EmployeeModel({
    String? id,
    String? firstName,
    String? lastName,
    bool? isDeleted,
    String? userRole,
    String? userId,
    UserModel? userDetail,
    String? updatedAt,
    String? createdAt,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _isDeleted = isDeleted;
    _userRole = userRole;
    _userId = userId;
    _userDetail = userDetail;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
  }

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _userId = json['userId'];
    _isDeleted = json['isDeleted'];
    _userRole = json['userRole'];
    _updatedAt = json['updatedAt'];
    _createdAt = json['createdAt'];
    _userDetail = json['userDetail'] != null
        ? UserModel.fromJson(json['userDetail'])
        : null;
  }

  EmployeeModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? userId,
    bool? isDeleted,
    String? userRole,
    UserModel? userDetail,
    String? updatedAt,
    String? createdAt,
  }) =>
      EmployeeModel(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        userId: userId ?? _userId,
        isDeleted: isDeleted ?? _isDeleted,
        userRole: userRole ?? _userRole,
        userDetail: userDetail ?? _userDetail,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
      );

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get userId => _userId;

  bool? get isDeleted => _isDeleted;

  String? get userRole => _userRole;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  UserModel? get userDetail => _userDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['userId'] = _userId;
    map['isDeleted'] = _isDeleted;
    map['userRole'] = _userRole;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_userDetail != null) {
      map['userDetail'] = _userDetail!.toJson();
    }
    return map;
  }
}
