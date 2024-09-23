import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';

abstract class CalendarRepository {
  Future<Either<List<SalesOrderModel>, String>> getAllSalesOrder(
      DateTime startDateOfWeek, DateTime lastDateOfWeek);

  Future<Either<bool, String>> addSalesOrder(SalesOrderParam salesOrderParam);

  Future<Either<SalesOrderModel, String>> getSalesOrder(String id);

  Future<Either<SalesOrderModel, String>> updateSalesOrder(
      String orderId, SalesOrderParam salesOrderParam);
}
