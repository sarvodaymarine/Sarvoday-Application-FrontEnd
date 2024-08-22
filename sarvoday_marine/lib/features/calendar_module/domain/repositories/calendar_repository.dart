import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';

abstract class CalendarRepository {
  Future<Either<List<SalesOrderModel>, CommonFailure>> getAllSalesOrder();

  Future<Either<bool, CommonFailure>> addSalesOrder(
      SalesOrderParam salesOrderParam);

  Future<Either<SalesOrderModel, CommonFailure>> getSalesOrder(String id);

  Future<Either<SalesOrderModel, CommonFailure>> updateSalesOrder(
      String orderId, SalesOrderParam salesOrderParam);
}
