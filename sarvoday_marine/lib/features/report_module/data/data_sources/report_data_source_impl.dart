import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/report_module/data/data_sources/report_data_source.dart';
import 'package:sarvoday_marine/features/report_module/data/models/report_model.dart';
import 'package:sarvoday_marine/features/report_module/data/models/service_report.dart';
import 'package:sarvoday_marine/features/report_module/domain/use_cases/update_report_use_case.dart';

class ReportDataSourceImpl implements ReportDataSource {
  final Dio dio;

  ReportDataSourceImpl(this.dio);

  @override
  Future<Either<ReportModel, CommonFailure>> getReport(String id) async {
    try {
      final response =
          await dio.get('${StringConst.backEndBaseURL}reports/getReport/$id');
      if (response.statusCode == 200) {
        return left(ReportModel.fromJson(response.data));
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }

  @override
  Future<Either<CommonFailure, ReportModel>> updateReport(
      String reportId, String serviceId, ServiceContainerModel param) async {
    try {
      final response = await dio.put(
          '${StringConst.backEndBaseURL}reports/updateReport/$reportId/serviceReport/$serviceId',
          data: jsonEncode(param.toJson()),
          options: await CommonMethods.getAuthenticationToken());
      if (response.statusCode == 200) {
        return Right(ReportModel.fromJson(response.data));
      } else {
        return Left(ErrorFailure(
            CommonMethods.commonValidation(response.statusMessage.toString())));
      }
    } catch (error) {
      return Left(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }

  @override
  Future<Either<ServiceContainerModel, CommonFailure>> getServiceReport(
      String serviceId) async {
    try {
      final response = await dio.get(
          '${StringConst.backEndBaseURL}reports/getServiceReport/$serviceId');
      if (response.statusCode == 200) {
        if (response.data != null) {
          return left(ServiceContainerModel.fromJson(response.data));
        } else {
          return right(ErrorFailure("Not found"));
        }
      } else {
        return right(ErrorFailure("Not found"));
      }
    } catch (error) {
      return right(
          ErrorFailure(CommonMethods.commonValidation(error.toString())));
    }
  }
}
