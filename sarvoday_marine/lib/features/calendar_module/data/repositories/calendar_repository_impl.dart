import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/calendar_module/data/data_sources/calendar_data_source.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDataSource calendarDataSource;

  CalendarRepositoryImpl(this.calendarDataSource);

  @override
  Future<Either<bool, CommonFailure>> addSalesOrder(
      SalesOrderParam salesOrderParam) async {
    return await calendarDataSource.addSalesOrder(salesOrderParam);
  }

  @override
  Future<Either<List<SalesOrderModel>, CommonFailure>>
      getAllSalesOrder() async {
    return await calendarDataSource.getAllSalesOrder();
  }

  @override
  Future<Either<SalesOrderModel, CommonFailure>> getSalesOrder(
      String id) async {
    return await calendarDataSource.getSalesOrder(id);
  }

  @override
  Future<Either<SalesOrderModel, CommonFailure>> updateSalesOrder(
      String orderId, SalesOrderParam salesOrderParam) async {
    return await calendarDataSource.updateSalesOrder(orderId, salesOrderParam);
  }
}
