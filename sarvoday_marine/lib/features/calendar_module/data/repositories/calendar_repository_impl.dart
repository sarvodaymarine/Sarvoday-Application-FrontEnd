import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/calendar_module/data/data_sources/calendar_data_source.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDataSource calendarDataSource;

  CalendarRepositoryImpl(this.calendarDataSource);

  @override
  Future<Either<bool, String>> addSalesOrder(
      SalesOrderParam salesOrderParam) async {
    return await calendarDataSource.addSalesOrder(salesOrderParam);
  }

  @override
  Future<Either<List<SalesOrderModel>, String>> getAllSalesOrder(
      DateTime startDateOfWeek, DateTime lastDateOfWeek) async {
    return await calendarDataSource.getAllSalesOrder(
        startDateOfWeek, lastDateOfWeek);
  }

  @override
  Future<Either<SalesOrderModel, String>> getSalesOrder(String id) async {
    return await calendarDataSource.getSalesOrder(id);
  }

  @override
  Future<Either<SalesOrderModel, String>> updateSalesOrder(
      String orderId, SalesOrderParam salesOrderParam) async {
    return await calendarDataSource.updateSalesOrder(orderId, salesOrderParam);
  }
}
