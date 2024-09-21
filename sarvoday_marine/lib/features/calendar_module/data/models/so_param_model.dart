class SalesOrderParam {
  String? locationName;
  String? locationAddress;
  String? clientId;
  String? clientName;
  List<SoEmployeeParam>? employeeList;
  DateTime? orderDate;
  int? noOfContainer;
  String? products;
  List<SoServiceParam>? services;
  List<ExpenseParam>? otherExpenses;
  List<TaxParam>? tax;
  String? comments;

  SalesOrderParam(
      {this.locationName,
      this.locationAddress,
      this.clientId,
      this.clientName,
      this.orderDate,
      this.noOfContainer,
      this.products,
      this.services,
      this.employeeList,
      this.otherExpenses,
      this.tax,
      this.comments});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['locationName'] = locationName;
    map['locationAddress'] = locationAddress;
    map['clientId'] = clientId;
    map['clientName'] = clientName;
    map['orderDate'] = orderDate?.toIso8601String();
    map['noOfContainer'] = noOfContainer;
    map['products'] = products;
    if (services != null) {
      map['services'] = services?.map((v) => v.toJson()).toList();
    }
    if (employeeList != null) {
      map['employees'] = employeeList?.map((v) => v.toJson()).toList();
    }
    if (otherExpenses != null) {
      map['otherExpenses'] = otherExpenses?.map((v) => v.toJson()).toList();
    }
    if (tax != null) {
      map['tax'] = tax?.map((v) => v.toJson()).toList();
    }
    map['comments'] = comments;
    return map;
  }
}

class SoServiceParam {
  SoServiceParam({
    this.serviceId,
    this.serviceName,
    this.priceType,
    this.price,
    this.totalPrice,
  });

  String? serviceId;
  String? serviceName;
  String? priceType;
  double? price;
  double? totalPrice;

  factory SoServiceParam.fromJson(Map<String, dynamic> json) {
    return SoServiceParam(
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      priceType: json['priceType'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceId'] = serviceId;
    map['serviceName'] = serviceName;
    map['priceType'] = priceType;
    map['price'] = price;
    return map;
  }
}

class SoEmployeeParam {
  SoEmployeeParam({
    this.employeeId,
    this.employeeName,
    this.isAssigned,
  });

  String? employeeId;
  String? employeeName;
  bool? isAssigned;

  factory SoEmployeeParam.fromJson(Map<String, dynamic> json) {
    return SoEmployeeParam(
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      isAssigned: json['isAssigned'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['employeeId'] = employeeId;
    map['employeeName'] = employeeName;
    map['isAssigned'] = isAssigned;
    return map;
  }
}

class ExpenseParam {
  ExpenseParam({
    this.expenseName,
    this.price,
  });

  String? expenseName;
  double? price;

  factory ExpenseParam.fromJson(Map<String, dynamic> json) {
    return ExpenseParam(
      expenseName: json['expenseName'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['expenseName'] = expenseName;
    map['price'] = price;
    return map;
  }
}

class TaxParam {
  TaxParam({
    this.taxName,
    this.description,
    this.cGST,
    this.taxPrice,
    this.sGST,
  });

  String? taxName;
  String? description;
  double? taxPrice;
  double? cGST;
  double? sGST;

  factory TaxParam.fromJson(Map<String, dynamic> json) {
    return TaxParam(
      taxName: json['taxName'],
      description: json['description'],
      cGST: (json['cGST'] as num?)?.toDouble(),
      taxPrice: (json['taxPrice'] as num?)?.toDouble(),
      sGST: (json['sGST'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taxName'] = taxName;
    map['description'] = description;
    map['cGST'] = cGST;
    map['sGST'] = sGST;
    return map;
  }
}
