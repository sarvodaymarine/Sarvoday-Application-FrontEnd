import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sarvoday_marine/core/api_handler/token_manager.dart';
import 'package:sarvoday_marine/core/navigation/navigation_service.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 100),
        sendTimeout: const Duration(seconds: 100),
        receiveTimeout: const Duration(seconds: 100),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // This will only add Authorization header if it's not excluded
          if (options.extra['authRequired'] != false) {
            String? token = await TokenManager.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              if (options.contentType == null) {
                options.headers['Content-Type'] = 'application/json';
              }
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            _redirectToLogin();
          }
          return handler.next(error);
        },
      ),
    );
  }

  static DioClient getInstance() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  static errorHandler(BuildContext context, dynamic error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      CommonMethods.showToast(context, 'Request timed out. Please try again.');
    } else if (error.error is SocketException) {
      CommonMethods.showToast(
          context, 'No internet connection. Please check your network.');
    } else {
      CommonMethods.showToast(
          context, 'Unexpected error occurred: ${error.message}');
    }
  }

  void _redirectToLogin() {
    TokenManager.clearToken();
    NavigationService().navigateToLogin();
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      bool authRequired = true,
      Options? options}) async {
    return dio.get(
      url,
      queryParameters: queryParameters,
      options: options?.copyWith(extra: {'authRequired': authRequired}) ??
          Options(extra: {'authRequired': authRequired}),
    );
  }

  Future<Response> post(String url,
      {dynamic data, Options? options, bool authRequired = true}) async {
    return dio.post(
      url,
      data: data,
      options: options?.copyWith(extra: {'authRequired': authRequired}) ??
          Options(extra: {'authRequired': authRequired}),
    );
  }

  Future<Response> put(String url,
      {dynamic data, Options? options, bool authRequired = true}) async {
    return dio.put(
      url,
      data: data,
      options: options?.copyWith(extra: {'authRequired': authRequired}) ??
          Options(extra: {'authRequired': authRequired}),
    );
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? data, bool authRequired = true}) async {
    return dio.delete(
      url,
      data: data,
      options: Options(extra: {'authRequired': authRequired}),
    );
  }
}
