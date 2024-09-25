class UserModel {
  UserModel(
      {String? id,
      String? firstName,
      String? lastName,
      String? mobile,
      String? email,
      String? countryCode,
      bool? isActive,
      bool? isFirstLogin,
      bool? isPasswordReset,
      bool? isDeleted,
      String? designation,
      String? updatedAt,
      String? createdAt}) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _mobile = mobile;
    _email = email;
    _isFirstLogin = isFirstLogin;
    _countryCode = countryCode;
    _isActive = isActive;
    _isPasswordReset = isPasswordReset;
    _isDeleted = isDeleted;
    _designation = designation;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _mobile = json['mobile'];
    _countryCode = json['countryCode'];
    _isActive = json['isActive'];
    _isPasswordReset = json['isPasswordReset'] ?? false;
    _isDeleted = json['isDeleted'];
    _designation = json['userRole'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _createdAt = json['createdAt'];
    _isFirstLogin = json['isFirstLogin'];
  }

  String? _id;
  String? _firstName;
  String? _lastName;
  String? _mobile;
  String? _email;
  String? _countryCode;
  bool? _isActive;
  bool? _isPasswordReset;
  bool? _isDeleted;
  String? _designation;
  String? _updatedAt;
  String? _createdAt;
  bool? _isFirstLogin;

  UserModel copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          String? mobile,
          String? email,
          String? countryCode,
          bool? isActive,
          bool? isPasswordReset,
          bool? isDeleted,
          bool? isFirstLogin,
          String? designation,
          String? updatedAt,
          String? createdAt}) =>
      UserModel(
          id: id ?? _id,
          firstName: firstName ?? _firstName,
          lastName: lastName ?? _lastName,
          mobile: mobile ?? _mobile,
          email: email ?? _email,
          countryCode: countryCode ?? _countryCode,
          isDeleted: isDeleted ?? _isDeleted,
          isFirstLogin: isFirstLogin ?? _isFirstLogin,
          isActive: isActive ?? _isActive,
          isPasswordReset: isPasswordReset ?? _isPasswordReset,
          updatedAt: updatedAt ?? _updatedAt,
          createdAt: createdAt ?? _createdAt);

  String? get id => _id;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get mobile => _mobile;

  String? get email => _email;

  String? get countryCode => _countryCode;

  bool? get isActive => _isActive;

  bool? get isPasswordReset => _isPasswordReset;

  bool? get isFirstLogin => _isFirstLogin;

  bool? get isDeleted => _isDeleted;

  String? get designation => _designation;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['countryCode'] = _countryCode;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['designation'] = _designation;
    map['createdAt'] = _createdAt;
    map['isPasswordReset'] = _isPasswordReset;
    map['isFirstLogin'] = _isFirstLogin;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
