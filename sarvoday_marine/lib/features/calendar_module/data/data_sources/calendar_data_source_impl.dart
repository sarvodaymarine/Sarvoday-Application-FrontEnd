import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/calendar_module/data/data_sources/calendar_data_source.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';

class CalendarDataSourceImpl implements CalendarDataSource {
  final Dio dio;

  CalendarDataSourceImpl(this.dio);

  @override
  Future<Either<bool, CommonFailure>> addSalesOrder(
      SalesOrderParam salesOrderParam) async {
    try {
      final response = await dio.post(
          '${StringConst.backEndBaseURL}orders/addSalesOrder',
          data: jsonEncode(salesOrderParam.toJson()),
          options: await CommonMethods.getAuthenticationToken());
      if (response.statusCode == 200) {
        return const Left(true);
      } else {
        return Right(ErrorFailure(
            CommonMethods.commonValidation(response.statusMessage.toString())));
      }
    } catch (error) {
      return Right(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }

  @override
  Future<Either<List<SalesOrderModel>, CommonFailure>>
      getAllSalesOrder() async {
    try {
      final response = await dio.get(
          '${StringConst.backEndBaseURL}orders/getAllSalesOrders',
          options: await CommonMethods.getAuthenticationToken());
      if (response.statusCode == 200) {
        final List<SalesOrderModel> salesOrder = [];
        final jsonList = response.data;
        for (var item in jsonList) {
          salesOrder.add(SalesOrderModel.fromJson(item));
        }
        return left(salesOrder);
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }

  @override
  Future<Either<SalesOrderModel, CommonFailure>> getSalesOrder(
      String id) async {
    try {
      final response =
          await dio.get('${StringConst.backEndBaseURL}orders/getOrder/$id');
      if (response.statusCode == 200) {
        return left(SalesOrderModel.fromJson(response.data));
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }

  @override
  Future<Either<SalesOrderModel, CommonFailure>> updateSalesOrder(
      String orderId, SalesOrderParam salesOrderParam) async {
    try {
      final response = await dio.put(
          '${StringConst.backEndBaseURL}orders/updateSalesOrder/$orderId',
          data: jsonEncode(salesOrderParam.toJson()),
          options: await CommonMethods.getAuthenticationToken());
      if (response.statusCode == 200) {
        return Left(SalesOrderModel.fromJson(response.data));
      } else {
        return Right(ErrorFailure(
            CommonMethods.commonValidation(response.statusMessage.toString())));
      }
    } catch (error) {
      return Right(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }
}
