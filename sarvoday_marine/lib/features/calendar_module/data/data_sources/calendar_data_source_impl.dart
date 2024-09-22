import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/calendar_module/data/data_sources/calendar_data_source.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';

class CalendarDataSourceImpl implements CalendarDataSource {
  final DioClient dio;

  CalendarDataSourceImpl(this.dio);

  @override
  Future<Either<bool, String>> addSalesOrder(
      SalesOrderParam salesOrderParam) async {
    try {
      final response = await dio.post(
          '${StringConst.backEndBaseURL}orders/addSalesOrder',
          data: jsonEncode(salesOrderParam.toJson()));
      if (response.statusCode == 200) {
        return const Left(true);
      } else {
        return Right(CommonMethods.commonErrorHandler(response));
      }
    } catch (error) {
      return Right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<List<SalesOrderModel>, String>> getAllSalesOrder(
      DateTime startDateOfWeek, DateTime lastDateOfWeek) async {
    try {
      final startDate = DateTime(startDateOfWeek.year, startDateOfWeek.month, startDateOfWeek.day, 0, 0, 0, 0, 0).toUtc();
      final endDate = DateTime(lastDateOfWeek.year, lastDateOfWeek.month, lastDateOfWeek.day, 23, 59, 59, 999, 999).toUtc();
      final response = await dio.get(
          '${StringConst.backEndBaseURL}orders/getAllSalesOrders/$startDate/$endDate');
      if (response.statusCode == 200) {
        final List<SalesOrderModel> salesOrder = [];
        final jsonList = response.data;
        for (var item in jsonList) {
          salesOrder.add(SalesOrderModel.fromJson(item));
        }
        return left(salesOrder);
      } else {
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<SalesOrderModel, String>> getSalesOrder(String id) async {
    try {
      final response =
          await dio.get('${StringConst.backEndBaseURL}orders/getOrder/$id');
      if (response.statusCode == 200) {
        return left(SalesOrderModel.fromJson(response.data));
      } else {
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<SalesOrderModel, String>> updateSalesOrder(
      String orderId, SalesOrderParam salesOrderParam) async {
    try {
      final response = await dio.put(
          '${StringConst.backEndBaseURL}orders/updateSalesOrder/$orderId',
          data: jsonEncode(salesOrderParam.toJson()));
      if (response.statusCode == 200) {
        return Left(SalesOrderModel.fromJson(response.data));
      } else {
        return Right(CommonMethods.commonErrorHandler(response));
      }
    } catch (error) {
      return Right(CommonMethods.commonErrorHandler(error));
    }
  }
}
