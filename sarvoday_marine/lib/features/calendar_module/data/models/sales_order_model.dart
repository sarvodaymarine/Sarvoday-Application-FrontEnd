import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';

class SalesOrderModel {
  String? _id;
  String? _locationName;
  String? _clientId;
  String? _clientName;
  String? _orderDate;
  int? _noOfContainer;
  String? _products;
  String? _orderId;
  String? _status;
  List<SoServiceParam>? _services;
  List<SoEmployeeParam>? _employeeList;
  List<TaxParam>? _tax;
  String? _comments;
  List<ExpenseParam>? _otherExpenses;
  String? _updatedAt;
  String? _createdAt;
  double? _totalTax;
  double? _totalInvoice;

  SalesOrderModel({
    String? id,
    String? locationName,
    String? clientId,
    String? clientName,
    String? orderDate,
    int? noOfContainer,
    String? products,
    double? totalTax,
    double? totalInvoice,
    String? orderId,
    String? status,
    List<SoServiceParam>? services,
    List<SoEmployeeParam>? employeeList,
    List<TaxParam>? tax,
    List<ExpenseParam>? otherExpenses,
    String? comments,
    String? updatedAt,
    String? createdAt,
  }) {
    _id = id;
    _locationName = locationName;
    _clientId = clientId;
    _clientName = clientName;
    _orderDate = orderDate;
    _noOfContainer = noOfContainer;
    _products = products;
    _totalTax = totalTax;
    _totalInvoice = totalInvoice;
    _orderId = orderId;
    _status = status;
    _services = services;
    _employeeList = employeeList;
    _tax = tax;
    _otherExpenses = otherExpenses;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _comments = comments;
  }

  SalesOrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _locationName = json['locationName'];
    _clientId = json['clientId'];
    _clientName = json['clientName'];
    _orderDate = json['orderDate'];
    _noOfContainer = json['noOfContainer'];
    _products = json['products'];
    _totalTax = json['totalTax'] is int
        ? json['totalTax'].toDouble()
        : json['totalTax'];
    _totalInvoice = json['totalInvoice'] is int
        ? json['totalInvoice'].toDouble()
        : json['totalInvoice'];
    _orderId = json['orderId'];
    _status = json['status'];
    _comments = json['comments'];
    _services = (json['services'] as List<dynamic>?)
        ?.map((item) => SoServiceParam.fromJson(item))
        .toList();
    _employeeList = (json['employees'] as List<dynamic>?)
        ?.map((item) => SoEmployeeParam.fromJson(item))
        .toList();
    _tax = (json['tax'] as List<dynamic>?)
        ?.map((item) => TaxParam.fromJson(item))
        .toList();
    _otherExpenses = (json['otherExpenses'] as List<dynamic>?)
        ?.map((item) => ExpenseParam.fromJson(item))
        .toList();
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  SalesOrderModel copyWith({
    String? id,
    String? locationName,
    String? clientId,
    String? clientName,
    String? orderDate,
    int? noOfContainer,
    String? products,
    double? totalTax,
    double? totalInvoice,
    String? orderId,
    String? status,
    List<SoServiceParam>? services,
    List<SoEmployeeParam>? employeeList,
    List<TaxParam>? tax,
    List<ExpenseParam>? otherExpenses,
    String? comments,
    String? updatedAt,
    String? createdAt,
  }) {
    return SalesOrderModel(
      id: id ?? _id,
      locationName: locationName ?? _locationName,
      clientId: clientId ?? _clientId,
      clientName: clientName ?? _clientName,
      orderDate: orderDate ?? _orderDate,
      noOfContainer: noOfContainer ?? _noOfContainer,
      products: products ?? _products,
      totalTax: totalTax ?? _totalTax,
      totalInvoice: totalInvoice ?? _totalInvoice,
      orderId: orderId ?? _orderId,
      status: status ?? _status,
      services: services ?? _services,
      employeeList: employeeList ?? _employeeList,
      tax: tax ?? _tax,
      otherExpenses: otherExpenses ?? _otherExpenses,
      comments: comments ?? _comments,
      updatedAt: updatedAt ?? _updatedAt,
      createdAt: createdAt ?? _createdAt,
    );
  }

  String? get id => _id;

  String? get locationName => _locationName;

  String? get clientId => _clientId;

  String? get clientName => _clientName;

  String? get orderDate => _orderDate;

  int? get noOfContainer => _noOfContainer;

  String? get products => _products;

  double? get totalTax => _totalTax;

  double? get totalInvoice => _totalInvoice;

  String? get status => _status;

  String? get orderId => _orderId;

  List<SoServiceParam>? get services => _services;

  List<SoEmployeeParam>? get employeeList => _employeeList;

  List<TaxParam>? get tax => _tax;

  String? get comments => _comments;

  List<ExpenseParam>? get otherExpenses => _otherExpenses;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['locationName'] = _locationName;
    map['clientId'] = _clientId;
    map['clientName'] = _clientName;
    map['orderDate'] = _orderDate;
    map['noOfContainer'] = _noOfContainer;
    map['products'] = _products;
    map['orderId'] = _orderId;
    map['status'] = _status;
    map['comments'] = _comments;
    map['services'] = _services?.map((service) => service.toJson()).toList();
    map['employees'] =
        _employeeList?.map((employee) => employee.toJson()).toList();
    map['tax'] = _tax?.map((tax) => tax.toJson()).toList();
    map['otherExpenses'] =
        _otherExpenses?.map((expense) => expense.toJson()).toList();
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
