import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/navigation/navigation_service.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/report_module/data/data_sources/report_data_source.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';

class ReportDataSourceImpl implements ReportDataSource {
  final DioClient dio;

  ReportDataSourceImpl(this.dio);

  @override
  Future<Either<ReportModel, String>> getReport(String id) async {
    try {
      final response =
          await dio.get('${StringConst.backEndBaseURL}reports/getReport/$id');
      if (response.statusCode == 200) {
        return left(ReportModel.fromJson(response.data));
      } else {
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<String, ServiceContainerModel>> updateReport(String reportId,
      String serviceId, ServiceContainerModel param, bool isReviewed) async {
    try {
      final response = await dio.put(
          '${StringConst.backEndBaseURL}reports/updateReport/$reportId/serviceReport/$serviceId/$isReviewed',
          options: Options(receiveTimeout: const Duration(seconds: 300)),
          data: jsonEncode(param.toJson()));
      if (response.statusCode == 401) {
        NavigationService().navigateToLogin();
        return Left(CommonMethods.commonErrorHandler(response));
      } else if (response.statusCode == 200) {
        return Right(ServiceContainerModel.fromJson(response.data));
      } else {
        return Left(CommonMethods.commonErrorHandler(response));
      }
    } catch (error) {
      return Left(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<ServiceContainerModel, String>> getServiceReport(
      String serviceId) async {
    try {
      final response = await dio.get(
          '${StringConst.backEndBaseURL}reports/getServiceReport/$serviceId');
      if (response.statusCode == 200) {
        if (response.data != null) {
          return left(ServiceContainerModel.fromJson(response.data));
        } else {
          return right("Not found");
        }
      } else {
        return right("Not found");
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }
}
